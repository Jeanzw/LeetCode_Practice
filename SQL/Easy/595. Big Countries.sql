select name,population,area from World
where area >= 3000000 or population >= 25000000


-- Python
import pandas as pd

def big_countries(world: pd.DataFrame) -> pd.DataFrame:
    world = world.query("area >= 3000000 or population >= 25000000")
    return world[['name','population','area']]