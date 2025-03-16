/* Question 1 */

USE schools;
DROP TABLE IF EXISTS school_src_staging;
DROP TABLE IF EXISTS school_salary_src_staging;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS salaries;
SET FOREIGN_KEY_CHECKS = 1;

DROP TABLE IF EXISTS school_conf;

CREATE TABLE school_src_staging
LIKE school_src;
INSERT INTO school_src_staging
SELECT * FROM school_src;

CREATE TABLE school_salary_src_staging
LIKE school_salary_src;
INSERT INTO school_salary_src_staging
SELECT * FROM school_salary_src;

SELECT * FROM school_src_staging;

# Update Conferences
SELECT * FROM school_src_staging
    WHERE school_name = 'Stanford University' OR 
          school_name = 'University of California, Berkeley';
UPDATE school_src_staging
SET conference = 'ACC'
WHERE school_name = 'Stanford University' OR 
          school_name = 'University of California, Berkeley';

SELECT * FROM school_src_staging
    WHERE school_name IN ('Arizona State University (ASU)', 'University of Arizona', 
						'University of Colorado - Boulder (UCB)', 'University of Utah');
UPDATE school_src_staging
SET conference = 'Big 12'   
WHERE school_name IN ('Arizona State University (ASU)', 'University of Arizona', 
						'University of Colorado - Boulder (UCB)', 'University of Utah');
                        
SELECT * FROM school_src_staging
    WHERE school_name IN ('University of California at Los Angeles (UCLA)', 'University of Oregon', 
						'University of Washington (UW)');    					
UPDATE school_src_staging
SET conference = 'Big Ten'                          
WHERE school_name IN ('University of California at Los Angeles (UCLA)', 'University of Oregon', 
						'University of Washington (UW)');                            
                        
# See what schools don't match
UPDATE school_src_staging
SET school_name = TRIM(school_name);

UPDATE school_salary_src_staging
SET school = TRIM(school);
        					
SELECT s1.school_name AS unmatched_src, NULL AS unmatched_salary
FROM school_src_staging s1
LEFT JOIN school_salary_src_staging s2 ON s1.school_name = s2.school
WHERE s2.school IS NULL
UNION
SELECT NULL AS unmatched_src, s2.school AS unmatched_salary
FROM school_salary_src_staging s2
LEFT JOIN school_src_staging s1 ON s1.school_name = s2.school
WHERE s1.school_name IS NULL;

UPDATE school_src_staging
SET school_name = 'Rutgers University'
WHERE school_name = 'Rutgers';

UPDATE school_src_staging
SET school_name = 'University of Notre Dame'
WHERE school_name = 'Notre Dame';

UPDATE school_src_staging
SET school_name = 'University of Central Florida (UCF)'
WHERE school_name = 'University of Central Florida';

UPDATE school_src_staging
SET school_name = 'University of Houston (UH)'
WHERE school_name = 'University of Houston';

# See if there are any empty strings in either table
SELECT * FROM school_src_staging
where school_name = '' OR
conference = '';

SELECT * FROM school_salary_src_staging
WHERE school = '' OR
region = '' OR
starting_median = '' OR
mid_career_median = '' OR
mid_career_90 = '';

UPDATE school_salary_src_staging
SET starting_median = NULL
WHERE starting_median = '';

UPDATE school_salary_src_staging
SET mid_career_median = NULL
WHERE mid_career_median = '';

UPDATE school_salary_src_staging
SET mid_career_90 = NULL
WHERE mid_career_90 = '';

# Change Salary Format to Decimals
UPDATE school_salary_src_staging
SET starting_median = REPLACE(REPLACE(starting_median, '$', ''), ',', '');

UPDATE school_salary_src_staging
SET mid_career_median = REPLACE(REPLACE(mid_career_median, '$', ''), ',', '');

UPDATE school_salary_src_staging
SET mid_career_90 = REPLACE(REPLACE(mid_career_90, '$', ''), ',', '');

# Create Target Tables
SELECT MAX(LENGTH(school_name)), MAX(LENGTH(conference))
FROM school_src_staging;

SELECT MAX(LENGTH(school)), MAX(LENGTH(region)), MAX(LENGTH(starting_median)), MAX(LENGTH(mid_career_median)), MAX(LENGTH(mid_career_90))
FROM school_salary_src_staging;

CREATE TABLE salaries(
school VARCHAR(67) PRIMARY KEY,
region VARCHAR(12) CHECK(region IN ('Northeastern', 'Southern', 'Western','Midwestern', 'California')),
starting_median DECIMAL(10,2),
mid_career_median DECIMAL(10,2),
mid_career_90 DECIMAL(10,2)
);

CREATE TABLE school_conf(
school VARCHAR(67) PRIMARY KEY ,
conference VARCHAR(11) CHECK(conference IN('SEC','Patriot','Big 12', 'ACC', 'Big Ten', 'Independent', 'Pac-12')),
FOREIGN KEY (school) REFERENCES salaries(school)
);

# Add Into Target Tables
INSERT INTO salaries
SELECT * FROM school_salary_src_staging;

INSERT INTO school_conf
SELECT * FROM school_src_staging;

SELECT COUNT(*) FROM salaries;
SELECT COUNT(*) FROM school_conf;

/* Question 2 */
SELECT 
school, 
region, 
CONCAT('$',FORMAT(starting_median,2)) AS starting_median, 
CONCAT('$',FORMAT(mid_career_median,2)) AS mid_career_median, 
CONCAT('$',FORMAT(mid_career_90,2)) AS mid_career_90
FROM salaries;

/* Question 3 */
SELECT conference, 
COUNT(school) As 'Number of Schools'
FROM school_conf    
GROUP BY conference
ORDER BY COUNT(school) DESC, conference;

/* Question 4 */
SELECT * 
FROM salaries
WHERE school LIKE '%Tech%'
ORDER BY starting_median DESC;

/* Question 5 */

SELECT 
school, 
CONCAT('$',FORMAT(starting_median,2)) AS starting_median, 
CONCAT('$',FORMAT(mid_career_median,2)) AS mid_career_median, 
CONCAT('$',FORMAT(mid_career_90,2)) AS mid_career_90
FROM salaries
WHERE school IN ('Fairleigh Dickinson University', 'Princeton University',
				'Rider University','Rutgers University', 
				'Seton Hall University', 'Stevens Institute of Technology')
ORDER BY school;

/* Question 6 */
SELECT 
sc.conference, 
s.region
FROM school_conf sc 
JOIN salaries s 
ON s.school = sc.school
GROUP BY sc.conference, s.region
ORDER BY sc.conference;

/* Question 7 */
SELECT 
s.school, 
sc.conference, 
s.starting_median, 
s.mid_career_median, 
s.mid_career_90
FROM salaries s
JOIN school_conf sc ON sc.school = s.school
WHERE sc.conference = 'Big Ten'
ORDER BY s.mid_career_median DESC;

/* Question 8  */
SELECT 
s.school,
sc.conference,
s.region,
s.starting_median, 
s.mid_career_median, 
s.mid_career_90
FROM salaries s
LEFT JOIN school_conf sc ON sc.school = s.school
ORDER BY s.mid_career_median DESC
LIMIT 1;

/* Question 9 */
SELECT 
conference, 
COUNT(school) AS Member_Count
FROM school_conf
WHERE conference != 'Big Ten'
GROUP BY conference
ORDER BY COUNT(school) DESC;


       