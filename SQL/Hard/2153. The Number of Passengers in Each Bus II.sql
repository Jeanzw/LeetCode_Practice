WITH RECURSIVE

    -- Add a "previous bus time" column:
    upd_buses AS (
        SELECT
            B.bus_id,
            B.arrival_time,
            B.capacity,
            COALESCE(LAG(B.arrival_time) OVER (ORDER BY B.arrival_time), 0) AS prev_bus_time
        FROM Buses B
    ),

    -- For each bus, add a new_pax column showing how many new passengers
    -- arrived to the bus stop since the last bus
    running_totals AS (
        SELECT
            B.bus_id,
            B.arrival_time,
            B.capacity,
            B.prev_bus_time,
            COUNT(P.passenger_id) AS new_pax,
            ROW_NUMBER() OVER (ORDER BY B.arrival_time) AS row_num
        FROM upd_buses AS B

        LEFT JOIN Passengers P
        ON
            P.arrival_time <= B.arrival_time
            AND
            P.arrival_time > B.prev_bus_time

        GROUP BY B.bus_id, B.arrival_time, B.capacity
    ),

    -- Use a recursive CTE to build the final table row-by-row. "Boarded" is how many
    -- people entered the bus, and "remaining" is how many didn't fit in.
    recursive_cte AS (
        -- Base - select first row
        SELECT
            row_num,
            bus_id,
            LEAST(capacity, new_pax) AS boarded,
            (new_pax - LEAST(capacity, new_pax)) AS remaining
        FROM running_totals
        WHERE row_num = 1

        UNION ALL

        -- Create all other rows, by combining the next row from the `running_totals` table,
        -- and the previously built row from this CTE
        SELECT
            T.row_num,
            T.bus_id,
            LEAST(capacity, new_pax + remaining) AS boarded,
            (new_pax + remaining) - LEAST(capacity, new_pax + remaining) AS remaining
        FROM
            recursive_cte REC,
            running_totals T
        WHERE
            T.row_num = REC.row_num + 1
    )

-- The data is ready, just select the columns we need
SELECT
    bus_id,
    boarded AS passengers_cnt
FROM recursive_cte
ORDER BY bus_id

--------------------------------

-- Python
import pandas as pd

def number_of_passengers(buses: pd.DataFrame, passengers: pd.DataFrame) -> pd.DataFrame:
    # Sort buses by their arrival times to process in chronological order
    buses_sorted = buses.sort_values(by='arrival_time')

    # Iterate over each bus to calculate the number of passengers it can pick up
    for i, bus in buses_sorted.iterrows():
        # For the first bus, count all passengers arrived up to its arrival time
        if i == 0:
            available_passengers = passengers[passengers['arrival_time'] <= bus.arrival_time].shape[0]
        else:
            # For subsequent buses, count passengers arrived after the previous bus and before this bus
            arrived_after_previous_bus = passengers['arrival_time'] > buses_sorted.at[i - 1, 'arrival_time']
            arrived_before_current_bus = passengers['arrival_time'] <= bus.arrival_time
            available_passengers = passengers[arrived_after_previous_bus & arrived_before_current_bus].shape[0]
            available_passengers += buses_sorted.at[i - 1, 'leftover']

        # Determine how many passengers board this bus based on its capacity
        if available_passengers <= bus.capacity:
            buses_sorted.at[i, 'passengers_cnt'] = available_passengers
            buses_sorted.at[i, 'leftover'] = 0
        else:
            buses_sorted.at[i, 'passengers_cnt'] = bus.capacity
            buses_sorted.at[i, 'leftover'] = available_passengers - bus.capacity

    # Return the result with bus ID and the count of passengers picked up by each bus
    return buses_sorted[['bus_id', 'passengers_cnt']].sort_values(by='bus_id')
