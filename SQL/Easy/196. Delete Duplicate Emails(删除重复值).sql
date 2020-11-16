-- 其实我们可以这么想，就是把相同email的id较大的给抽出来
-- 然后直接把select换成delete

DELETE p1 FROM Person p1,
    Person p2
WHERE
    p1.Email = p2.Email AND p1.Id > p2.Id
