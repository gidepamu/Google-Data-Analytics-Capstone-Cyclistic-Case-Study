# Google-Data-Analytics-Capstone-Cyclistic-Case-Study
This is my project that I've been working on in Google Data Analytics Capstone Project

Course: [Proyek Akhir Analitis Data Google: Selesaikan Sebuah Studi Kasus](https://www.coursera.org/learn/proyek-akhir-analitis-data-google-selesaikan-sebuah-studi-kasus)

## Introduction
In this case study, I will perform many real-world tasks of a junior data analyst at a fictional company, Cyclistic. In order to answer the key business questions, I will be using my understanding of the analysis process which is: Ask, Prepare, Process, Analyze, Share & Act.

In this case would be sharing how I approached this case study, and for my choice of weapon, I would be using RStudio and Tableau in this Case Study.

## Scenario
You are a junior data analyst working in the marketing analyst team at Cyclistic, a bike-sharing company in Chicago. Moreno (director of marketing) believes the company’s future success depends on maximizing the number of annual memberships. Our goal is to design marketing strategies aimed at converting casual riders into annual members. In order to do that, we need to understand how casual riders and annual members use Cyclistic bikes differently.

## About the Company
Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.

Cyclistic’s finance analysts have concluded that annual members are much more profitable than casual riders. Although the pricing flexibility helps Cyclistic attract more customers, Moreno believes that maximizing the number of annual members will be key to future growth. Rather than creating a marketing campaign that targets all-new customers, Moreno believes there is a very good chance to convert casual riders into members. She notes that casual riders are already aware of the Cyclistic program and have chosen Cyclistic for their mobility needs.

Moreno has set a clear goal: Design marketing strategies aimed at converting casual riders into annual members. In order to do that, however, the marketing analyst team needs to better understand how annual members and casual riders differ, why casual riders would buy a membership, and how digital media could affect their marketing tactics. Moreno and her team are interested in analyzing the Cyclistic historical bike trip data to identify trends.

## Ask
These are the questions/business task that would guide the future of the marketing program:

- To understand how annual members and casual riders use our Cyclistic bikes differently
- Why would casual members upgrade to annual memberships
- How can Cyclistic use digital media to influence casual riders to become members?

[Overall Goal](): Design marketing strategies aimed at converting casual riders into annual members.

[Business Question](): "How do annual members and casual riders use Cyclistic bikes differently?"

## Prepare
In this case study I will use data from Cyclistics historical trip data which can be accessed at this link: [here](https://divvy-tripdata.s3.amazonaws.com/index.html) and The data that I use is 2023 data from January - December. 
![image](https://github.com/gidepamu/Google-Data-Analytics-Capstone-Cyclistic-Case-Study/assets/89971566/e30b577a-b866-44d1-9a24-99fd5e40abea)

*_The above data has been provided by Motivate International Inc. based on this license [link](https://divvybikes.com/data-license-agreement)_

## Process
I first analyzed the data using the Excel application. Aiming to explore the data about what information is in the data. Then I used R tools to clean the data and analyze the data as a whole.
First, it is necessary to install and load some necessary packages such as: Tidyverse, hms, data.table & Lubridate.
```
#melakukan load beberapa library
library(tidyverse)
library(lubridate)
library(hms)
library(data.table)
```
Subsequently, we would need to import the csv’s into Rstudio, in which we would use read_csv.
```
# melakukan load data csv Cyclistic pada tahun 2023
jan_01_df <- read_csv("dataset/202301-divvy-tripdata.csv")
feb_02_df <- read_csv("dataset/202302-divvy-tripdata.csv")
mar_03_df <- read_csv("dataset/202303-divvy-tripdata.csv")
apr_04_df <- read_csv("dataset/202304-divvy-tripdata.csv")
mei_05_df <- read_csv("dataset/202305-divvy-tripdata.csv")
jun_06_df <- read_csv("dataset/202306-divvy-tripdata.csv")
jul_07_df <- read_csv("dataset/202307-divvy-tripdata.csv")
agu_08_df <- read_csv("dataset/202308-divvy-tripdata.csv")
sep_09_df <- read_csv("dataset/202309-divvy-tripdata.csv")
okt_010_df <- read_csv("dataset/202310-divvy-tripdata.csv")
nov_011_df <- read_csv("dataset/202311-divvy-tripdata.csv")
des_012_df <- read_csv("dataset/202312-divvy-tripdata.csv")
```
The next step would be to merge all the csv’s(which we will now call dataset) into one table then deleted the previous dataframe and then create a new dataframe to create a new column
```
# dari beberapa dataframe digabungkan menjadi satu dataframe
cyclistic_df <- rbind(jan_01_df, feb_02_df, mar_03_df, apr_04_df, mei_05_df, jun_06_df, jul_07_df, agu_08_df, sep_09_df, okt_010_df, nov_011_df, des_012_df)

# hapus dataframe karena sudah dimerge jadi satu
remove(jan_01_df, feb_02_df, mar_03_df, apr_04_df, mei_05_df, jun_06_df, jul_07_df, agu_08_df, sep_09_df, okt_010_df, nov_011_df, des_012_df)

# membuat dataframe baru untuk memuat kolom baru
new_cyclistic_df <- cyclistic_df
```
create new columns such as: Ride Length (subtract end_at_time from start_at_time), Day of the Week, Month, Day, Year, Time, Hour, Season, and Time of date
### Ride Length
```
# menghitung panjang perjalanan dengan mengurangkan waktu_akhir dari waktu_awal dan mengubahnya menjadi menit
new_cyclistic_df$ride_length <- difftime(cyclistic_df$ended_at, cyclistic_df$started_at, units = 'mins')
new_cyclistic_df$ride_length <- round(new_cyclistic_df$ride_length, digits = 1)
```
### Day of the Week, Month, Day, Year, Time, Hour
```
# membuat kolom baru: day of week, month, day, year, time, hour
new_cyclistic_df$date <- as.Date(new_cyclistic_df$started_at)
new_cyclistic_df$day_of_week <- wday(cyclistic_df$started_at) #menghitung day of the week 
new_cyclistic_df$day_of_week <- format(as.Date(new_cyclistic_df$date), "%A") #membuat column untuk day of week
new_cyclistic_df$month <- format(as.Date(new_cyclistic_df$date), "%m")#membuat column untuk month
new_cyclistic_df$day <- format(as.Date(new_cyclistic_df$date), "%d") #membuat column untuk day
new_cyclistic_df$year <- format(as.Date(new_cyclistic_df$date), "%Y") #membuat column untuk year
new_cyclistic_df$time <- format(as.Date(new_cyclistic_df$date), "%H:%M:%S") #format time menjadi HH:MM:SS
new_cyclistic_df$time <- as_hms((cyclistic_df$started_at)) #membuat column baru untuk time
new_cyclistic_df$hour <- hour(new_cyclistic_df$time) #membuat column baru untuk hour
```
### Season
```
# membuat kolom untuk membagi ke beberapa musim: Spring, Summer, Fall, Winter
new_cyclistic_df <-new_cyclistic_df %>% mutate(season = 
                                             case_when(month == "03" ~ "Spring",
                                                       month == "04" ~ "Spring",
                                                       month == "05" ~ "Spring",
                                                       month == "06"  ~ "Summer",
                                                       month == "07"  ~ "Summer",
                                                       month == "08"  ~ "Summer",
                                                       month == "09" ~ "Fall",
                                                       month == "10" ~ "Fall",
                                                       month == "11" ~ "Fall",
                                                       month == "12" ~ "Winter",
                                                       month == "01" ~ "Winter",
                                                       month == "02" ~ "Winter")
)
```
### Time of date
```
# membuat kolom untuk perbedaan waktu
new_cyclistic_df <-new_cyclistic_df %>% mutate(time_of_day = 
                                             case_when(hour == "0" ~ "Night",
                                                       hour == "1" ~ "Night",
                                                       hour == "2" ~ "Night",
                                                       hour == "3" ~ "Night",
                                                       hour == "4" ~ "Night",
                                                       hour == "5" ~ "Night",
                                                       hour == "6" ~ "Morning",
                                                       hour == "7" ~ "Morning",
                                                       hour == "8" ~ "Morning",
                                                       hour == "9" ~ "Morning",
                                                       hour == "10" ~ "Morning",
                                                       hour == "11" ~ "Morning",
                                                       hour == "12" ~ "Afternoon",
                                                       hour == "13" ~ "Afternoon",
                                                       hour == "14" ~ "Afternoon",
                                                       hour == "15" ~ "Afternoon",
                                                       hour == "16" ~ "Afternoon",
                                                       hour == "17" ~ "Afternoon",
                                                       hour == "18" ~ "Evening",
                                                       hour == "19" ~ "Evening",
                                                       hour == "20" ~ "Evening",
                                                       hour == "21" ~ "Evening",
                                                       hour == "22" ~ "Evening",
                                                       hour == "23" ~ "Evening")
)
```
### Month
```
# membuat kolom untuk bulan
new_cyclistic_df <-new_cyclistic_df %>% mutate(month = 
                                             case_when(month == "01" ~ "January",
                                                       month == "02" ~ "February",
                                                       month == "03" ~ "March",
                                                       month == "04" ~ "April",
                                                       month == "05" ~ "May",
                                                       month == "06" ~ "June",
                                                       month == "07" ~ "July",
                                                       month == "08" ~ "August",
                                                       month == "09" ~ "September",
                                                       month == "10" ~ "October",
                                                       month == "11" ~ "November",
                                                       month == "12" ~ "December"
                                                       )
)
```

### Cleaning Data
```
#cleaning data
new_cyclistic_df <- na.omit(new_cyclistic_df) #menghapus rows dengan nilai NA atau nilai kosong
new_cyclistic_df <- distinct(new_cyclistic_df) #menghapus duplicate rows 
new_cyclistic_df <- new_cyclistic_df[!(new_cyclistic_df$ride_length <=0),] #menghapus nilai ride_length yang memiliki nilai 0 atau negative
new_cyclistic_df <- new_cyclistic_df %>%  #Menhapus kolom yang tidak digunakan: ride_id, start_station_id, end_station_id, start_lat, start_long, end_lat, end_lng
  select(-c(ride_id, start_station_id, end_station_id,start_lat,start_lng,end_lat,end_lng)) 
```

### Convert file into .csv for visualization with Tableau
```
#membuuat dataframe baru untuk digunakan pada Tableau
cyclistic_tableau <- new_cyclistic_df

#clean the data
cyclistic_tableau <- cyclistic_tableau %>%  #menghapus kolom: start_station_name, end_station_name, time, started_at, ended_at
  select(-c(start_station_name, end_station_name, time, started_at, ended_at))

#download data baru yang berbentuk .csv file
fwrite(cyclistic_tableau,"cyclistic_tableu.csv")
```

## Analyze & Share
Now it’s time to analyze the data and look for key information that we can perform analysis on, and afterward, plot/visualize it!In order to answer our first business question, it would be beneficial to plot a few of our observations revolving around:
1. Total Rides by User Type
  Members had more rides with 2,793,601 total rides or 65% and casual riders had 1,529,656 total rides or 35%.
  ![total ride by user type](https://github.com/gidepamu/Google-Data-Analytics-Capstone-Cyclistic-Case-Study/assets/89971566/b8ac9ddd-6979-4d81-987a-1c35f03803d3)
2. Total Rides per Bike Type
  Both casual riders and members used the classic bike the most with 2,686,041 rides or 62% of total rides, followed by electric bikes with 1,561,588 rides or 36% of total rides, and lastly with docked bikes at 76,048 rides or 2% of total rides.
  ![image](https://github.com/gidepamu/Google-Data-Analytics-Capstone-Cyclistic-Case-Study/assets/89971566/0ead78e9-c2f9-497d-973b-830e2d9092d3)
3. Total Rides by Hour
  5PM or 17:00 was the busiest hour for both members and casual riders with 453,240 rides or 10% of the total rides. Typically rides began increasing in the morning at 6AM and rose until 5PM then dropped afterwards. The afternoon was the busiest for both rider types of total rides. 3AM was the least popular hour.
  ![total ride by hour](https://github.com/gidepamu/Google-Data-Analytics-Capstone-Cyclistic-Case-Study/assets/89971566/156ebc19-e905-4315-8b59-02534cfdf766)
4. Total Rides by Weekday
  Saturday was the most popular weekday combining casual riders and member rides of total rides. Based on the weekday graph, it would further reinforce my previous hypothesis whereby annual members are working adults, as we can see from:
 - 7 am-8 am: A rally in usage, which could indicate when they’ve begun commuting to work
 - 12 pm: An increase in usage, which would indicate lunch hour
 - 5 pm: A peak in usage, which again falls in line with the office off-hours
   
 ![total ride by weekday](https://github.com/gidepamu/Google-Data-Analytics-Capstone-Cyclistic-Case-Study/assets/89971566/1a498fde-ccee-424f-9de8-5dfa3223df05)
 
5. Total Rides by Month
   August was the busiest month combining casual riders and member rides at 583,826 rides or 14% of total rides. While summer was the most popular season for both of total rides. Winter is the least popular season and January is the least popular month.
   ![total ride by month](https://github.com/gidepamu/Google-Data-Analytics-Capstone-Cyclistic-Case-Study/assets/89971566/23a645a0-c407-4a17-b95f-98753db78e4c)

## Act
After identifying the differences between casual and member riders, marketing strategies to target casual riders can be developed to persuade them to become members.
- We can clearly see a peak in casual riders on a few occasions: On the weekends as well as in the months of June, July & August. we should prioritize marketing on the said occasions.
- As a follow up to the previous suggestions, we should advertise promotions on the previous point whereby current casual members would be able to upgrade to annual members at a discount.
- I would suggest strategically enforcing location-based advertisements (featured on Instagram & Facebook) to target the popular stations among the casual members.

## Dashboard
Below of the dashboard using Tableau [here](https://public.tableau.com/views/GoogleDataAnalyticsCapstoneCyclisticCaseStudy_17177879497660/Dashboard3?:language=en-US&publish=yes&:sid=&:display_count=n&:origin=viz_share_link)
![Dashboard 3 (1)](https://github.com/gidepamu/Google-Data-Analytics-Capstone-Cyclistic-Case-Study/assets/89971566/3cc478d1-1f7b-485c-b1a0-bcd7b50d17f1)



 
 

