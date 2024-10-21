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
SELECT cost_sum AS total_cost, CONCAT('{', tour, ',', point2, '}') AS tour
FROM a_tour
WHERE
    LENGTH(tour) = 7
    AND point2 = 'a'
ORDER BY total_cost ASC, tour ASC;