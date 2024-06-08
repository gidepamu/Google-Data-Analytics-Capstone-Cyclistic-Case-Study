# melakukan load beberapa library
library(tidyverse)
library(lubridate)
library(hms)
library(data.table)

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

# dari beberapa dataframe digabungkan menjadi satu dataframe
cyclistic_df <- rbind(jan_01_df, feb_02_df, mar_03_df, apr_04_df, mei_05_df, jun_06_df, jul_07_df, agu_08_df, sep_09_df, okt_010_df, nov_011_df, des_012_df)

# hapus dataframe karena sudah dimerge jadi satu
remove(jan_01_df, feb_02_df, mar_03_df, apr_04_df, mei_05_df, jun_06_df, jul_07_df, agu_08_df, sep_09_df, okt_010_df, nov_011_df, des_012_df)

# membuat dataframe baru untuk memuat kolom baru
new_cyclistic_df <- cyclistic_df

# menghitung panjang perjalanan dengan mengurangkan waktu_akhir dari waktu_awal dan mengubahnya menjadi menit
new_cyclistic_df$ride_length <- difftime(cyclistic_df$ended_at, cyclistic_df$started_at, units = 'mins')
new_cyclistic_df$ride_length <- round(new_cyclistic_df$ride_length, digits = 1)

# membuat kolom baru: day of week, month, day, year, time, hour
new_cyclistic_df$date <- as.Date(new_cyclistic_df$started_at)
new_cyclistic_df$day_of_week <- wday(cyclistic_df$started_at) #calculate the day of the week 
new_cyclistic_df$day_of_week <- format(as.Date(new_cyclistic_df$date), "%A") #create column for day of week
new_cyclistic_df$month <- format(as.Date(new_cyclistic_df$date), "%m")#create column for month
new_cyclistic_df$day <- format(as.Date(new_cyclistic_df$date), "%d") #create column for day
new_cyclistic_df$year <- format(as.Date(new_cyclistic_df$date), "%Y") #create column for year
new_cyclistic_df$time <- format(as.Date(new_cyclistic_df$date), "%H:%M:%S") #format time as HH:MM:SS
new_cyclistic_df$time <- as_hms((cyclistic_df$started_at)) #create new column for time
new_cyclistic_df$hour <- hour(new_cyclistic_df$time) #create new column for hour

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

#cleaning data
new_cyclistic_df <- na.omit(new_cyclistic_df) #menghapus rows dengan nilai NA atau nilai kosong
new_cyclistic_df <- distinct(new_cyclistic_df) #menghapus duplicate rows 
new_cyclistic_df <- new_cyclistic_df[!(new_cyclistic_df$ride_length <=0),] #menghapus nilai ride_length yang memiliki nilai 0 atau negative
new_cyclistic_df <- new_cyclistic_df %>%  #Menhapus kolom yang tidak digunakan: ride_id, start_station_id, end_station_id, start_lat, start_long, end_lat, end_lng
  select(-c(ride_id, start_station_id, end_station_id,start_lat,start_lng,end_lat,end_lng)) 

#membuuat dataframe baru untuk digunakan pada Tableau
cyclistic_tableau <- new_cyclistic_df

#clean the data
cyclistic_tableau <- cyclistic_tableau %>%  #menghapus kolom: start_station_name, end_station_name, time, started_at, ended_at
  select(-c(start_station_name, end_station_name, time, started_at, ended_at))

#download data baru yang berbentuk .csv file
fwrite(cyclistic_tableau,"cyclistic_tableu.csv")