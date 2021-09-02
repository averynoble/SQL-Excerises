-- 1 What grades are stored in the database?
SELECT * 
FROM Grade; -- 1st Grade, 2nd Grade, 3rd Grade, 4th Grade, 5th Grade

	
-- 2 What emotions may be associated with a poem?
SELECT * FROM Emotion; -- Anger, Fear, Sadness, Joy


-- 3 How many poems are in the database?
SELECT COUNT(Poem.Id)
FROM Poem;  -- 32842


-- 4 Sort authors alphabetically by name. What are the names of the top 76 authors?
SELECT TOP(76) Author.Name
From Author
ORDER BY Author.Name; -- .lilly thru abdul


-- 5 Starting with the above query, add the grade of each of the authors.
SELECT TOP(76) Author.Name, Grade.Name
FROM Author
LEFT JOIN Grade ON Grade.Id = Author.GradeId
ORDER BY Author.Name; -- .lilly 2nd Grade thru Abdul 5th Grade


-- 6 Starting with the above query, add the recorded gender of each of the authors.
SELECT TOP(76) Author.Name, Grade.Name, Gender.Name
FROM Author
LEFT JOIN Grade ON Grade.Id = Author.GradeId
LEFT JOIN Gender ON Gender.Id = Author.GenderId
ORDER BY Author.Name; -- .lilly 2nd Grade NA thru Abdul 5th Grade Male


-- 7 What is the total number of words in all poems in the database?
SELECT SUM(Poem.WordCount) AS TotalWords FROM Poem; -- 374,584 Words


-- 8 Which poem has the fewest characters?
SELECT Poem.CharCount AS FewestChars, Poem.Title AS Title 
FROM Poem
WHERE Poem.CharCount = (SELECT MIN(Poem.CharCount) FROM Poem); -- 6 Chars, Title = Hi


-- 9 How many authors are in the third grade?
SELECT COUNT(Author.GradeId) AS ThirdGradeAuth
FROM Author
LEFT JOIN Grade ON Grade.Id = Author.GradeId
WHERE Author.GradeId = 3; --2344 3rd Grade Authors

-- 10 How many total authors are in the first through third grades?
SELECT COUNT(Author.GradeId) AS FirstThruThird
FROM Author
JOIN Grade ON Grade.Id = Author.GradeId
WHERE Author.GradeId = 3 OR Author.GradeId = 2 OR Author.GradeId = 1; -- 9096 Authors From 1st thru 3rd Grade


-- 11 What is the total number of poems written by fourth graders?
SELECT COUNT(Poem.Id) AS ForthGrader
FROM Poem
JOIN Author ON Poem.AuthorId = Author.Id
JOIN Grade ON Author.GradeId =  Grade.Id
WHERE Grade.Id = 4; -- 10806 4th grade Poems


-- 12 How many poems are there per grade?
SELECT COUNT(Poem.Id) AS Grades
FROM Poem
JOIN Author ON Poem.AuthorId = Author.Id
JOIN Grade ON Author.GradeId =  Grade.Id
GROUP BY Grade.Name; -- 1st 886, 2nd 3160, 3rd 6636, 4th 10806, 5th 11354


-- 13 How many authors are in each grade? (Order your results by grade starting with 1st Grade)
SELECT COUNT(Author.GradeId) AS Grades
FROM Author
JOIN Grade ON Author.GradeId = Grade.Id
GROUP BY Grade.Name; --1st = 623, 2nd = 1437, 3rd = 2344, 4th = 3288, 5th = 3464


-- 14 What is the title of the poem that has the most words?
SELECT Poem.WordCount AS longesttitle, Poem.Title
FROM Poem
WHERE Poem.WordCount = (SELECT MAX(Poem.WordCount) FROM Poem); -- Longest 263 Words Title = The Misterious Black


-- 15 Which author(s) have the most poems? (Remember authors can have the same name.)
SELECT (Author.Id), Author.Name, COUNT(*) 'NumOfPoems'
FROM Author
JOIN Poem ON Poem.AuthorId = Author.Id
GROUP BY Author.Id, Author.Name
ORDER BY 'NumOfPoems' DESC; -- Jessica = 118, Emily = 115, Emily = 98


-- 16 How many poems have an emotion of sadness?
SELECT COUNT(Poem.id) AS NumOfPoems, Emotion.Name AS Emotion
FROM Poem
JOIN PoemEmotion ON Poem.Id = PoemEmotion.PoemId
JOIN Emotion ON PoemEmotion.EmotionId = Emotion.Id
WHERE Emotion.Name = 'sadness'
GROUP BY Emotion.Name; -- 14,570


-- 17 How many poems are not associated with any emotion?
SELECT COUNT(Poem.Id) 'NumOfPoems', Emotion.Name 'Emotion'
FROM Poem
LEFT JOIN PoemEmotion ON Poem.Id = PoemEmotion.PoemId
LEFT JOIN Emotion ON PoemEmotion.EmotionId = Emotion.Id
WHERE Emotion.Name IS NULL
GROUP BY Emotion.Name -- 3,368

-- 18 Which emotion is associated with the least number of poems?
SELECT TOP 1 COUNT(Poem.Id) 'NumOfPoems', Emotion.Name
FROM Poem
JOIN PoemEmotion ON Poem.Id = PoemEmotion.EmotionId
JOIN Emotion ON PoemEmotion.EmotionId = Emotion.Id
GROUP BY Emotion.Name
ORDER BY NumOfPoems ASC -- Anger


-- 19 Which grade has the largest number of poems with an emotion of joy?
SELECT TOP 1 g.Name AS Grade, COUNT(po.Id) AS NumOfPoems, e.Name AS Emotion
FROM Poem po
JOIN PoemEmotion pe ON po.Id = pe.PoemId
JOIN Emotion e ON pe.EmotionId = e.Id
JOIN Author a ON po.AuthorId = a.Id
JOIN Grade g ON g.Id = a.GradeId
WHERE e.Name = 'Joy'
GROUP BY g.Name, e.Name
ORDER BY NumOfPoems DESC; -- 5th Grade

-- 20 Which gender has the least number of poems with an emotion of fear?
SELECT TOP 1 Gender.Name AS Gender, COUNT(Poem.id) AS NumOfPoems, Emotion.Name AS Emotion
FROM Poem
JOIN PoemEmotion ON Poem.Id = PoemEmotion.PoemId
JOIN Emotion ON PoemEmotion.EmotionId = Emotion.Id
JOIN Author ON Poem.AuthorId = Author.Id
JOIN Gender ON Gender.Id = Author.GenderId
JOIN Grade ON Grade.Id = Author.GradeId
WHERE Emotion.Name= 'Fear'
GROUP BY Gender.Name, Emotion.Name
ORDER BY NumOfPoems ASC; -- Ambiguous