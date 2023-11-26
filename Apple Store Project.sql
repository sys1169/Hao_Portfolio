--select * from AppleStore
--select * from appleStore_description

-- Main objective: which genre/paid or free and price/language/file size/Number of supporting devices/content rating/ to choose

-- check the number of unique apps in both df
--select distinct COUNT(*), COUNT(*)
--from AppleStore

--select distinct COUNT(*), COUNT(*)
--from appleStore_description

-- ans: 7196 unique apps with no duplication


-- check for any missing value in key values
--select * from AppleStore
--where 
--	track_name is null or
--	price is null or
--	user_rating is null or
--	prime_genre is null

--select * from appleStore_description
--where app_desc is null

-- ans: no missing value


-- data cleaning
--Update AppleStore
--set price = ROUND(price, 2)
--Update AppleStore
--set track_name = TRIM(track_name)
--Update appleStore_description
--set app_desc = TRIM(app_desc)
--alter table appleStore_description
--drop column track_name,size_bytes


-- find the number of apps per genre and market distribution%
--select 
--	prime_genre, 
--	COUNT(*) as apps_count, 
--	ROUND((CAST(COUNT(*) as float)/(select(COUNT(*)) from AppleStore))*100,2) as market_percent 
--from AppleStore
--group by prime_genre
--order by market_percent desc


-- find the number of free apps vs paid apps
--select
--	COUNT(case when price=0 then 1 end) as free_apps,
--	COUNT(case when price>0 then 1 end) as paid_apps
--from AppleStore

-- ans: 4056 free apps and 3140 paid apps


-- determine whether paid apps have higher rating than free apps. If yes, is expensive app have higher rating than cheap apps?
--with cte as(
--select *,
--case	when price = 0 then 'free'
--		when price between 0.99 and 2.99 then '0.99 to 2.99'
--		else '>2.99'
--		end as apps_price
--from AppleStore
--)
--select apps_price, COUNT(apps_price) as apps_count, ROUND(AVG(user_rating),2) as avg_rating
--from cte
--group by apps_price

-- ans: yes, paid apps have significant higher rating(3.72) than free apps(3.38)
--		the rating of apps with price>2.99 (3.78) only slightly higher than apps with price between 0.99~2.99(3.69)


-- check of apps with more supported language have higher rating
--with cte as(
--select*,
--case	when lang_num =1 then 'only one language'
--		when lang_num between 2 and 10 then 'language between 2 and 10'
--		else 'language more than 10'
--end as language_count
--from AppleStore
--)
--select language_count, COUNT(language_count) as apps_count, ROUND(AVG(user_rating),2) as rating
--from cte
--group by language_count

-- ans: apps with language more than 10 have significant higher rating (4.01)


-- check genres with TOP 3 highest and lowest ratings
--select TOP 3 prime_genre, ROUND(AVG(user_rating),2) as highest_rating
--from AppleStore
--group by prime_genre
--order by highest_rating desc

--select TOP 3 prime_genre, ROUND(AVG(user_rating),2) as lowest_rating
--from AppleStore
--group by prime_genre
--order by lowest_rating asc

-- ans: highest rating genres are [Productivity, Music, Photo&Video] 
--		lowest rating genres are [Catalogs, Finance, Book]


-- check the correlation between length of app_description and user rating (<1000,~2000,>2000)
--with cte as(
--select *,
--case	when len(app_desc)<1000 then 'short'
--		when len(app_desc) between 1000 and 2000 then 'medium'
--		else 'long'
--		end as app_desc_length
--from appleStore_description
--)
--Select app_desc_length, COUNT(app_desc_length) as apps_count, ROUND(AVG(user_rating),2) as avg_rating
--from cte
--join AppleStore	a on cte.id = a.id
--group by app_desc_length

-- ans: short description (<1000) have lowest avg_rating (2.94)
--		medium description (1000~2000) have normal avg_rating (3.77)
--		long description (<1000) have highest avg_rating (3.96)


-- find the top-rated app for each genre that have more than 500 comments
--with cte as(
--select *, RANK()over(partition by prime_genre order by user_rating desc) as rk
--from AppleStore
--)
--select prime_genre, track_name, user_rating
--from cte
--where rk = 1 and rating_count_tot >500

-- do people prefer smaller or larger size apps?
--with cte as(
--select *,
--case	when size_bytes<100000000 then 'small'
--		when size_bytes between 100000000 and 500000000 then 'medium'
--		else 'large'
--		end as app_size
--from AppleStore
--)
--select app_size, COUNT(app_size) as apps_count, ROUND(AVG(user_rating),2) as avg_rating
--from cte
--group by app_size

-- ans: small size apps have lowest avg_rating (3.29)
	--	medium size apps have normal avg_rating (3.77)
	--	large size apps have highest avg_rating (3.83)