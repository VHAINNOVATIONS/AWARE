






SELECT *, ROW_NUMBER() OVER (partition by A ORDER BY B desc) AS RowNumber 
FROM T

/*
PK	A	B	C	RowNumber
1	0	1	8	1
2	0	3	6	2
3	0	5	4	3
4	0	7	2	4
5	0	9	0	5
6	1	0	9	1
7	1	2	7	2
8	1	4	5	3
9	1	6	3	4
10	1	8	1	5
*/

select *
  from (
    select PK, A, B, C
            group by A
            Having A=MAX(A) 
        )  
        
go


SELECT *, ROW_NUMBER() OVER (partition by A ORDER BY B desc) AS RowNumber 
FROM T        

SELECT *, ROW_NUMBER() OVER (partition by A ORDER BY PK) AS RowNumber 
FROM T        
       
        
  