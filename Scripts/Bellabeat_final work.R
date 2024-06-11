# I. ASK - done
# II. PREPARE

# First of all, I'm going to install all the necessary packages and their libraries.

install.packages("tidyverse")
library(tidyverse)
library(ggplot2)
library(readr)

#The Skimr package makes summarizing data really easy and let's skim through it more quickly.
install.packages("skimr")
library(skimr)

#The Janitor package has functions for cleaning data.
install.packages("janitor")
library(janitor)

install.packages("dplyr")
library(dplyr)

#The HERE package makes referencing files easier. Be sure to install and load this package before trying to save CSV files.
install.packages("here")
library("here")

getwd()
setwd("D:\\Learning and Data Science\\Google Data Analytics\\Course 8_Google Data Analytics Capstone Complete a Case Study\\R")

activity <- read.csv("dailyActivity_merged.csv")
calories <- read.csv("dailyCalories_merged.csv")
intensities <- read.csv("dailyIntensities_merged.csv")
steps <- read.csv("dailySteps_merged.csv")
sleep <- read.csv("sleepDay_merged.csv")
weight <- read.csv("weightLogInfo_merged.csv")

#checking the activity's structure and more
#need to convert the 2nd column ActivityDate into correct date type
# 15 columns
head(activity)
str(activity)
#summary(activity)
#colnames(activity)
#View(activity)

#checking the calories' structure and more
#need to convert the 2nd column ActivityDay into correct date type
# 3 columns
head(calories)
#colnames(calories)
str(calories)
#summary(calories)
#View(calories)

#checking the intensities' structure and more
#need to convert the 2nd column ActivityDay into correct date type
# 10 columns
head(intensities)
str(intensities)
#colnames(intensities)
#summary(intensities)
#View(intensities)

#checking the steps' structure and more
#need to convert the 2nd column ActivityDay into correct date type
# 3 columns
head(steps)
str(steps)
#colnames(steps)
#summary(steps)
#View(steps)

#checking the sleep's structure and more
#need to convert the 2nd column SleepDay into correct date type
# 5 columns
head(sleep)
str(sleep)
#colnames(sleep)
#summary(sleep)
#View(sleep)

#checking the weight's structure and more
#need to convert the 2nd column Date into correct date type
# 8 columns
head(weight)
str(weight)
#colnames(weight)
#summary(weight)
#View(weight)

# III. Process

# Converting column names and fixing date formats

# activity
activity_new <- activity %>%
  rename_with(tolower) %>% #Convert column names to lowercase
  mutate(activitydate = as.Date(activitydate, format="%m/%d/%Y")) #fixing date formats
str(activity_new) #preview the result

#intensities
intensities_new <- intensities %>%
  rename_with(tolower) %>% #Convert column names to lowercase
  mutate(activityday = as.Date(activityday, format="%m/%d/%Y")) # fixing date formats
str(intensities_new) # preview the results

#calories
calories_new <- calories %>%
  rename_with(tolower) %>% #Convert column names to lowercase
  mutate(activityday = as.Date(activityday, format="%m/%d/%Y")) # fixing date formats
str(calories_new) # preview the results

#steps
steps_new <- steps %>%
  rename_with(tolower) %>% #Convert column names to lowercase
  mutate(activityday = as.Date(activityday, format="%m/%d/%Y")) # fixing date formats
str(steps_new) # preview the results

#sleep
# Now, I'm going to do the same thing, but with a different date-time format. The sleep dataset has the column SleepDay with a specific format: "4/12/2016 12:00:00 AM". I'm going to use as.POSIXct() function to parse the data accordingly.
#Before I do that, I need to check my locale settings. After that, I will set the locale settings to "en_US.UTF-8".
#Then, I will perform a series of tests in order to ensure that as.POSIXct() function works accordingly.

Sys.getlocale("LC_TIME")

# Save the current locale so I can restore it later
original_locale <- Sys.getlocale("LC_TIME")
# Set the locale to US English temporarily
Sys.setlocale("LC_TIME", "en_US.UTF-8")

# Test conversion of a single date-time string
test_date <- as.POSIXct("4/12/2016 12:00:00 AM", format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
print(test_date)
print(format(test_date, "%Y-%m-%d %H:%M:%S"))

# Test conversion with a different time
test_date_noon <- as.POSIXct("4/12/2016 12:00:00 PM", format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())
print(format(test_date_noon, "%Y-%m-%d %H:%M:%S"))

#sleep again
sleep_new <- sleep %>%
  rename_with(tolower) %>%  #Convert column names to lowercase
  mutate(sleepday = as.POSIXct(sleepday, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())) # fixing date formats
str(sleep_new) # preview the results

# Print the first few datetime values with explicit formatting just to check everything is ok
print(format(sleep_new$sleepday, "%Y-%m-%d %H:%M:%S"))

#weight
#Now, I need to follow the same steps as those for the sleep dataset.
weight_new <- weight %>%
  rename_with(tolower) %>%  #Convert column names to lowercase
  mutate(date = as.POSIXct(date, format="%m/%d/%Y %I:%M:%S %p", tz=Sys.timezone())) # fixing date formats
str(weight_new) # preview the results

# IV. Analyze

# Proceeding to the next steps; using n_distinct() function from the dplyr package. This function counts the number of unique values in a vector or column. 
# Exploring the data
n_distinct(activity_new$id)
n_distinct(intensities_new$id)
n_distinct(calories_new$id)
n_distinct(steps_new$id)
n_distinct(sleep_new$id)
n_distinct(weight_new$id)
#Results: This information tells us about the number of participants in each data sets. There are 33 participants in the activity, calories and intensities data sets, 24 in the sleep and only 8 in the weight data set. 8 participants is not significant to make any recommendations and conclusions based on this data.


# Next, let’s have a look at summary statistics of the data sets
#activity
View(activity_new)

activity_new %>%  
  select(totalsteps,
         totaldistance,
         sedentaryminutes, 
         calories) %>%
  summary()

#intensities
View(intensities_new)

intensities_new %>% 
  select(sedentaryminutes,
         lightlyactiveminutes,
         veryactiveminutes) %>% 
  summary(intensities_new)

#calories
View(calories_new)

calories_new %>% 
  select(calories) %>% 
  summary(calories_new)

#steps
View(steps_new)

steps_new %>% 
  select(steptotal) %>% 
  summary(steps_new)

#sleep
View(sleep_new)

sleep_new %>% 
  select(totalminutesasleep) %>% 
  summary(sleep_new)

#weight
View(weight_new)

weight_new %>% 
  select(weightkg,
         bmi) %>% 
  summary(weight_new)

#Findings:
# - The average total steps is 7638, which is relatively low comparing to the suggested 10000 steps per day by CDC to stay healthy.
# - The average sedentary minutes is 991.2 minutes, equivalents 16.52 hours (991.2/60), which should be considerably reduced.
# - The average lightlyactiveminutes is 192.8 and it suggests that the participants are mostly lightly active.
# - The average for veryactiveminutes is 21.16 which is very low!
# - Minutes asleep are at the minimum 58 and maximum 796, with an average of aprox. 420 min (7 hours) - which is good.
# - The average BMI is 25.19, which is overweight according to the standards from CDC (BMI ranges 18.5-24.9 is considered healthy). However, under the circumstances that the age and gender of the participants remained unknown, this could be biased.


# V. Share

# Hypotheses:

# 1. High Activity vs. Low Activity Days: On days with a higher number of steps, there will be a noticeable decrease in the number of sedentary minutes.
# Removing rows with missing data in the relevant columns
activity_new <- activity_new %>%
  filter(!is.na(totalsteps), !is.na(sedentaryminutes))

# Creating a scatter plot with regression line

ggplot(activity_new, aes(x = totalsteps, y = sedentaryminutes)) +
  geom_point(alpha = 0.5, color = "blue") +  # Points with transparency for better visualization
  geom_smooth(method = "lm", color = "red") +  # Linear regression line
  labs(title = "Relationship between Total Steps and Sedentary Minutes",
       x = "Total Steps",
       y = "Sedentary Minutes") +
  theme_minimal()

#Interpretation: 
#Given that the regression line starts higher on the y-axis and extends down as it moves to the right, this indicates a negative correlation. This means that generally, as the number of total steps increases, the sedentary minutes decrease.
#The presence of points above and below the regression line throughout the plot, especially if they're evenly distributed around the line, suggests that while there is a trend (higher steps are associated with fewer sedentary minutes), the relationship might not be very strong.
#Final conclusion of the 1st hypothesis: 
#The downward trend of the regression line supports the hypothesis that more total steps are associated with fewer sedentary minutes. However, the spread of points suggests that steps alone don't fully predict sedentary behavior.

# 2. Impact of Sleep on Activity: Days following more total sleep time will see an increase in total steps taken, assuming well-rested individuals are more active.

# Prepare the sleep data to match the next day's activity
sleep_new <- sleep_new %>% 
  mutate(sleepday_next = sleepday +1) # Create a column for the next day

# Merge the sleep data with activity data
combined_data_1 <- merge(activity_new, sleep_new, by.x = c("id", "activitydate"), by.y = c("id", "sleepday_next"))

# Check the merged data
head(combined_data_1)
View(combined_data_1)

# Remove rows with missing values in the relevant columns
combined_data_1 <- combined_data_1 %>%
  filter(!is.na(totalsteps), !is.na(totalminutesasleep))

# Creating a scatter plot of previous night's sleep vs. next day's total steps
ggplot(combined_data_1, aes(x = totalminutesasleep, y = totalsteps)) +
  geom_point(alpha = 0.5) +  # Semi-transparent points to handle overplotting
  geom_smooth(method = "lm", color = "blue") +  # Adds a linear regression line
  labs(title = "Impact of Sleep on Next Day's Activity",
       x = "Total Sleep Minutes (Previous Night)",
       y = "Total Steps (Next Day)") 
  theme_minimal()

# Interpretation:
#Because the regression line is nearly horizontal (almost flat), this implies that there is a weak relationship between the total minutes asleep and the total steps taken the next day. A nearly flat line suggests that changes in sleep duration do not significantly influence the number of steps taken.

  
# 3.Calories Burned and Active Minutes: There is a stronger correlation between calories burned and very active minutes compared to lightly active or sedentarily active minutes.

# Plot for Calories Burned vs. Very Active Minutes
ggplot(activity_new, aes(x = veryactiveminutes, y = calories)) +  # Initiate a ggplot graph, specify data source and aesthetics: x-axis for very active minutes and y-axis for calories
  geom_point(alpha = 0.4, color = "red") +  # Add scatter plot points with partial transparency (alpha = 0.4) and red color
  geom_smooth(method = "lm", color = "red") +  # Add a linear regression line to the plot to show the trend, colored red
  labs(title = "Calories Burned vs. Very Active Minutes",  # Add labels: set the title of the graph
        x = "Very Active Minutes",  # Label for the x-axis
        y = "Calories Burned") +  # Label for the y-axis
  theme_minimal()  # Use a minimal theme for the plot for a clean and modern look

# Interpretation:
# The upward slope of the regression line indicates a positive correlation between very active minutes and calories burned. This suggests that as the number of very active minutes increases, the number of calories burned also increases.

# Plot for Calories Burned vs. Lightly Active Minutes
ggplot(activity_new, aes(x = lightlyactiveminutes, y = calories)) +  # Initiate a ggplot graph, specify data source and aesthetics: x-axis for lightly active minutes and y-axis for calories
  geom_point(alpha = 0.4, color = "blue") +  # Add scatter plot points with partial transparency (alpha = 0.4) and blue color
  geom_smooth(method = "lm", color = "blue") +  # Add a linear regression line to the plot to show the trend, colored blue
  labs(title = "Calories Burned vs. Lightly Active Minutes",  # Add labels: set the title of the graph
       x = "Lightly Active Minutes",  # Label for the x-axis
       y = "Calories Burned") +  # Label for the y-axis
  theme_minimal()  # Use a minimal theme for the plot for a clean and modern look

#Interpretation:
#The near-flat slope of the blue regression line indicates a weak to moderate positive correlation between lightly active minutes and calories burned. This suggests that while there is some relationship where increased lightly active minutes correspond to an increase in calories burned, the relationship is not as strong or direct as with very active minutes.

# Plot for Calories Burned vs. Sedentary Minutes
ggplot(activity_new, aes(x = sedentaryminutes, y = calories)) +  # Initiate a ggplot graph, specify data source and aesthetics: x-axis for sedentary minutes and y-axis for calories
  geom_point(alpha = 0.4, color = "green") +  # Add scatter plot points with partial transparency (alpha = 0.4) and green color
  geom_smooth(method = "lm", color = "green") +  # Add a linear regression line to the plot to show the trend, colored green
  labs(title = "Calories Burned vs. Sedentary Minutes",  # Add labels: set the title of the graph
       x = "Sedentary Minutes",  # Label for the x-axis
       y = "Calories Burned") +  # Label for the y-axis
  theme_minimal()  # Use a minimal theme for the plot for a clean and modern look

#Interpretation:
#The almost flat or slightly downward slope of the green regression line indicates a weak negative correlation or no significant correlation between sedentary minutes and calories burned. This suggests that increased sedentary time does not lead to higher calorie burn and might slightly decrease it, which aligns with general health guidelines that recommend reducing sedentary time for better metabolic health.

#Interpretation for the whole H3:
#My hypothesis that there is a stronger correlation between calories burned and very active minutes compared to lightly active or sedentarily active minutes is supported by my analysis:
# *The most significant increase in calories burned is associated with very active minutes.
# *Lightly active minutes show some positive effect but not as pronounced.
# *Sedentary minutes do not contribute to calorie burning and may slightly reduce it.

# 4.BMI and Activity Levels: Individuals with a higher BMI will tend to have fewer total steps and more sedentary minutes.

# Merge the data frames based on 'id'
combined_data_2 <- merge(activity_new, weight_new, by = "id")
head(combined_data_2)

# Plot for BMI vs. Total Steps
ggplot(combined_data_2, aes(x = bmi, y = totalsteps)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "blue") +
  labs(title = "BMI vs. Total Steps",
       x = "BMI",
       y = "Total Steps") +
  theme_minimal()

#Interpretation:
#The downward slope of the regression line clearly suggests a negative correlation between BMI and total steps. This means that as BMI increases, the number of steps taken typically decreases. Starting from around 13,000 steps at the lower end of the BMI scale and decreasing to about 5,000 steps at higher BMI values reflects a significant reduction in physical activity as weight increases.

# Plot for BMI vs. Sedentary Minutes
ggplot(combined_data_2, aes(x = bmi, y = sedentaryminutes)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "BMI vs. Sedentary Minutes",
       x = "BMI",
       y = "Sedentary Minutes") +
  theme_minimal()

#Interpretation:
#The upward slope of the regression line indicates a positive correlation between BMI and sedentary minutes. This suggests that as BMI increases, individuals tend to have more sedentary minutes, aligning with your hypothesis that individuals with higher BMI will be more sedentary.

#The interpretation for the whole H4:
#Both analyses support the hypothesis that "Individuals with a higher BMI will tend to have fewer total steps and more sedentary minutes." The data clearly shows that as BMI increases, physical activity in the form of total steps decreases, while sedentary behavior increases.

# VI. Act