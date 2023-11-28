# Hospitality Revenue Dashboard (Power BI)
Case Study: Atliq Grands noticed a loss in their market share and revenue over a few months. To understand the causes, they need a way to analyze this.

## Objective
i. To create an interactive dashboard that displays key metrics for hospitality company.  
ii. To optimize the pricing strategy.  
iii. To provide recommendations aimed at increasing company's revenue. 

## 1. Set up interactive dashboard
### Star Schema

![gweq](https://github.com/sys1169/Hao_Portfolio/assets/59571707/cfe415b3-555b-4a2c-b346-e8bbc90df603)

### Dashboard Overview
![asdas](https://github.com/sys1169/Hao_Portfolio/assets/59571707/54f7b32e-1b3c-4278-8bc5-07b1df571afa)

<br>

## 2. Analyze key matrics

### Key Hospitality Performance Metrics: 'A Quick Guide' 
RevPar: Revenue Per Available Room (Total Revenue/ Total Rooms Available)  
ADR: Average Daily Rate (Total Revenue/Number of Rooms Sold)  
DSRN: Daily Sellable Room Night   
OCC%: Occupancy Rate (Total Rooms Occupied/Total Rooms Available)  
Realisation%:  Utilise Room Night / Booked Room Night  

![hagrf](https://github.com/sys1169/Hao_Portfolio/assets/59571707/5672e702-6447-45b8-bb6c-69f3e2215a74)

Notice that I create a filter that can sort the data by city, property, room class and date.

![aftaw](https://github.com/sys1169/Hao_Portfolio/assets/59571707/c3501ea0-1be5-406c-8317-448d617a00ee)

For example, I want to know the performance of <ins> Elite room of Atliq Exotica in Mumbai last month. </ins>

![hahaha](https://github.com/sys1169/Hao_Portfolio/assets/59571707/636fa8c1-c0da-490a-b924-64888e55f624)

The result shows that <ins>Elite room of Atliq Exotica in Mumbai</ins> did not perform well last month, as all of the key metrics are declining.

<br>

### 2.1 Weekend vs Weekday analysis
> Note: As a hospitality company, Weekend means Friday and Saturday.

![dew](https://github.com/sys1169/Hao_Portfolio/assets/59571707/56802a62-2096-41d7-9d2b-f187dd03341f)


According to the table, we know that the company focus on leisure hotel because the occupancy rate on weekend is much higher than weekday. However, the ADR for both weekend and weekday are almost equal, meaning that the company is not using <ins>Weekday/Weekend Pricing strategy</ins>.  
   
My personal suggestion to the company would be adjusting room rates based on the specific day of the week, with higher rates for weekends when demand is higher and lower rates for weekdays when demand is lower.

<br>

### 2.2 Transitioning from Flat to Dynamic Pricing


![412a](https://github.com/sys1169/Hao_Portfolio/assets/59571707/2fe45f8f-2cd4-4671-b95f-97e5ec624564)


Notice that RevPar and OCC% fluctuated week on week, but ADR remained constant, indicating that they sell their rooms at a flat rate.  

To maximizing revenue potential, it is advisable to adjust ADR in accordance with demand fluctuations. During periods of high demand, slightly increasing ADR can help manage occupancy and avoid overbooking, while lowering ADR during low-demand periods can attract more guests, leading to increased profitability. Therefore, I propose transitioning from flat pricing to <ins>dynamic pricing</ins>.

<br>

### 2.3 Promote the Official Website

![415a](https://github.com/sys1169/Hao_Portfolio/assets/59571707/7e1d5509-fa58-46fc-8d11-4354f6f10a64)

I observed that the hotel's direct online platform (official website), has the lowest Average Daily Rate (ADR) compared to other platforms. This can be attributed to the absence of a 10~25% commission fee that the hotel would otherwise pay to external booking platforms. However, the overall revenue and performance on the official website are not optimal.  

My strategy to enhance attractiveness of official website would be offering additional services, such as <ins>tickets for on-site facilities or creating bundled packages</ins> (e.g., providing two complimentary bottles of wine with a reservation made through the hotel's website).
 
> Note: Lowering prices on the official website is not recommended as the company may face the penalties from other booking platforms.

<br>

### 2.4 Employ the Pareto Principle

According to the Pareto Principle (or 80/20 rule), we understand that 80% of result come from 20% of effort. Therefore, we should prioritize on <ins>expanding and marketing the top 3 hotel</ins> which have a higher chance to yield significant return.

![Screenshot 2023-11-28 153136](https://github.com/sys1169/Hao_Portfolio/assets/59571707/d20a6abd-d8e3-41df-84a4-b7c5ef8a1a40)

![Screenshot 2023-11-28 153542](https://github.com/sys1169/Hao_Portfolio/assets/59571707/17a4911f-8b4e-4338-9294-b0ba1ea89701)

On the other hand, 80% of problems typically arise from the bottom 20% of hotels. The primary approach is to <ins>analyze the rating reviews of the lowest-rated hotels</ins>, identifying the issues customers face, and implementing targeted improvements. This is crucial because customer care about rating nowadays. Most hotels experience higher online bookings when their ratings are high. 

<br>

## Summary

In summary, I created an interactive Hospitality Revenue Dashboard using Power BI that included all important key matrics (e.g ADR) and trend.   


I recommend the following strategies: (1) apply Weekday/Weekend Pricing strategy to adjust pricing in response to the demand, (2) employ dynamic pricing instead of flat pricing to maximize revenue, (3) improve the performance of official website by offering tickets or creating bundled packages, and (4) prioritizing the top three hotels for expansion and marketing, addressing issues in the bottom 20% of hotels by analyzing rating reviews.

