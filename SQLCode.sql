-- Analyze the Key Factors Influencing APP RATING to Enhanced Customer Satisfaction 
select * from AppleStore_description
select * from AppleStore_rating

-- Check the number of unique apps in both df
select distinct COUNT(*), COUNT(*)
from AppleStore_description
select distinct COUNT(*), COUNT(*)
from AppleStore_rating
-- Ans: There are 7196 unique apps with no duplication

-- Data cleaning
alter table AppleStore_description
drop column currency,ver,cont_rating,sup_devices_num,ipadSc_urls_num,vpp_lic
alter table AppleStore_rating
drop column track_name,size_bytes
Update AppleStore_description
set price = ROUND(price, 2), track_name = TRIM(track_name), app_desc = TRIM(app_desc)

-- Check for any missing value in key values
select * from AppleStore_description
where 
	track_name is null or
	price is null or
	prime_genre is null or
	lang_num is null or
	app_desc is null
select * from AppleStore_rating
where 
	rating_count_tot is null or
	user_rating is null
-- Ans: There are no missing value

-- Find the number of apps per genre and market distribution(%)
select 
	prime_genre, 
	COUNT(*) as apps_count, 
	ROUND((CAST(COUNT(*) as float)/(select(COUNT(*)) from AppleStore_description))*100,2) as market_percent 
from AppleStore_description
group by prime_genre
order by market_percent desc
-- Ans: Games is the largest genre (53.65%), Catalogs is the smallest genre (only 10 apps)

-- Find the number of free apps vs paid apps
select
	COUNT(case when price=0 then 1 end) as free_apps,
	COUNT(case when price>0 then 1 end) as paid_apps
from AppleStore_description
-- Ans: 4056 free apps and 3140 paid apps

-- Determine whether paid apps have higher rating than free apps.
 If yes, does expensive app have higher rating than cheap apps?
with cte as(
select r.user_rating,
case	when price = 0 then 'free'
		when price between 0.99 and 2.99 then '0.99 to 2.99'
		else '>2.99'
		end as apps_price
from AppleStore_description d
join AppleStore_rating r
on d.id = r.id
)
select apps_price, COUNT(apps_price) as apps_count, ROUND(AVG(user_rating),2) as avg_rating
from cte
group by apps_price
-- Ans: Yes, paid apps have significant higher rating(3.72) than free apps(3.38)
--		Yes, the rating of expensive_apps(>$2.99) is slightly higher than cheap_apps ($0.99~$2.99)

-- Do apps with more supported language have higher rating?
with cte as(
select user_rating,
case	when lang_num =1 then 'only one language'
		when lang_num between 2 and 10 then 'between 2 and 10 languages'
		else 'more than 10 languages'
end as language_count
from AppleStore_description d
join AppleStore_rating r
on d.id = r.id
)
select language_count, COUNT(language_count) as apps_count, ROUND(AVG(user_rating),2) as rating
from cte
group by language_count
-- Ans: Yes, apps with more than 10 languages have significant higher rating (4.01)

-- Analyze the correlation between length of app_description and user rating
with cte as(
select user_rating,
case	when len(app_desc) <800 then 'short'
		when len(app_desc) between 800 and 1500 then 'medium'
		when len(app_desc) between 1501 and 2500 then 'long'
		else 'extra long'
		end as app_desc_length
from AppleStore_description d
join AppleStore_rating r
on d.id = r.id
)
Select app_desc_length, COUNT(app_desc_length) as apps_count, ROUND(AVG(user_rating),2) as avg_rating
from cte
group by app_desc_length
-- Ans: Short description (<800) have lowest avg_rating (2.77)
--		Medium description (800~1500) have normal avg_rating (3.62)
--		Long description (1501~2500) have highest avg_rating (3.91)
--		Extra long description (>2500) have highest avg_rating (3.95)
--		The length of app_description and user rating have a positive relationship

-- Show TOP 3 genres with highest and lowest ratings
select TOP 3 prime_genre, ROUND(AVG(user_rating),2) as highest_rating
from AppleStore_description d
join AppleStore_rating r
on d.id = r.id
group by prime_genre
order by highest_rating desc
-- Ans: Highest rating genres are [Productivity, Music, Photo&Video] 

-- Find the top-rated app for each genre that have more than 500 comments
with cte as(
select prime_genre, track_name, user_rating, rating_count_tot, RANK()over(partition by prime_genre order by user_rating desc) as rank
from AppleStore_description d
join AppleStore_rating r
on d.id = r.id
)
select prime_genre, track_name, user_rating
from cte
where rank = 1 and rating_count_tot >500

-- Do users prefer smaller apps?
with cte as(
select user_rating,
case	when size_bytes<100000000 then 'small'
		when size_bytes between 100000000 and 500000000 then 'medium'
		else 'large'
		end as app_size
from AppleStore_description d
join AppleStore_rating r
on d.id = r.id
)
select app_size, COUNT(app_size) as apps_count, ROUND(AVG(user_rating),2) as avg_rating
from cte
group by app_size
-- Ans: No, in fact, users tend to prefer larger apps(3.89) to smaller apps(3.29)
