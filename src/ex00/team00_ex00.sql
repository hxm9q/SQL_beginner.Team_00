CREATE TABLE nodes (
    point1 CHAR(1),
    point2 CHAR(1),
    cost INTEGER
);

INSERT INTO
    nodes (point1, point2, cost)
VALUES ('a', 'b', 10),
    ('b', 'a', 10),
    ('a', 'c', 15),
    ('c', 'a', 15),
    ('a', 'd', 20),
    ('d', 'a', 20),
    ('b', 'd', 25),
    ('d', 'b', 25),
    ('c', 'd', 30),
    ('d', 'c', 30),
    ('b', 'c', 35),
    ('c', 'b', 35);

WITH RECURSIVE
    a_tour AS (
        SELECT
            point1::text AS tour,
            point1,
            point2::text,
            cost,
            cost AS cost_sum
        FROM nodes
        WHERE
            point1 = 'a'
        UNION ALL
        SELECT CONCAT(dom.tour, ',', sub.point1), sub.point1, sub.point2, sub.cost, dom.cost_sum + sub.cost AS cost_sum
        FROM nodes AS sub
            INNER JOIN a_tour AS dom ON sub.point1 = dom.point2
        WHERE
            dom.tour NOT LIKE CONCAT('%', sub.point1, '%')
    )
SELECT cost_sum AS total_cost, CONCAT('{', tour, '}') as tour
FROM (
        SELECT CONCAT(tour, ',', point2) AS tour, cost_sum, RANK() OVER (
                ORDER BY cost_sum
            ) AS rank_v
        FROM a_tour
        WHERE
            LENGTH(tour) = 7
            AND point2 = 'a'
    ) AS f
WHERE
    rank_v = 1
ORDER BY total_cost ASC, tour ASC;