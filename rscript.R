################################################################################
##                          Class Project- Elisha Damor                                     ##
################################################################################
################################################################################
##                                  PopRunner caselet                         ##
################################################################################

# This script is based on the PopRunner data - PopRunner is an online retailer
# Use the caselet and data (consumer.csv, pop_up.csv, purchase.csv, email.csv) 
# on D2L to answer questions below
# In this script, we will use SQL to do descriptive statistics
# Think about the managerial implications as you go along

options(warn=-1)
library(sqldf)

################################################################################

setwd("C:/Users/Elish/OneDrive/Desktop/mgt_588/final assignment")
setwd("C:/Users/Elish/OneDrive/Desktop/mgt_588/final assignment")
setwd("C:/Users/Elish/OneDrive/Desktop/mgt_588/final assignment")
setwd("C:/Users/Elish/OneDrive/Desktop/mgt_588/final assignment")

consumer<-read.csv("consumer.csv",header=TRUE)
pop_up<- read.csv("pop_up.csv",header=TRUE)
purchase<-read.csv("purchase.csv",header=TRUE)
email<-read.csv("email.csv",header=TRUE)

# Let us first start with exploring various tables

################################################################################

# Using SQL's LIMIT clause, display first 5 rows of all the four tables

# observe different rows and columns of the tables

################################################################################

# Query 1) Display first 5 rows of consumer table

sqldf("
      SELECT * FROM consumer LIMIT 5
      ")

################################################################################

# Query 2) Display first 5 rows of pop_up table

sqldf("
    SELECT * FROM pop_up LIMIT 5
      ")

################################################################################

# Query 3) Display first 5 rows of purchase table

sqldf("
      SELECT * FROM purchase LIMIT 5
      ")

################################################################################

# Query 4) Display first 5 rows of email table

sqldf("
      SELECT * FROM email LIMIT 5
      ")

################################################################################

# Now, let's look at the descriptive statistics one table at a time: consumer table

# Query 5: Display how many consumers are female and male (column alias: gender_count), 
#          also show what is the average age (column alias: average_age) of consumers by gender

sqldf("
    SELECT COUNT(*) AS gender_count,
        AVG(age) AS average_age,
       gender FROM consumer 
 GROUP BY gender
      ")

# Interpret your output in simple English (1-2 lines):

#among consumers 6903 are female and 2129 are male,
#with average age of female being approx 31years (30.61394) and 32 years(32.45186) of male.
################################################################################

# Query 6: How many consumers are there in each loyalty status group (column alias: loyalty_count), 
# what is the average age (column alias: average_age) of consumers in each group
sqldf("
       SELECT COUNT(*) AS loyalty_count,
       AVG(age) AS average_age,
       loyalty_status FROM consumer
       GROUP BY loyalty_status
      ")

# Interpret your output in simple English (1-2 lines):

# There are 1529 consumers with approx 29 years (29.37345) of average age in 0 loyalty status group,
# 1740 consumers with approx 30 years (30.10345)of average age in 1 loyalty status group, 
# 2612 consumers with approx 31 years (30.69908)of average age in 2 loyalty status group, 
# 1385 consumers with approx 32 years (31.59278) of average age in 3 loyalty status group
# and 1766 consumers with approx 34 years (33.51302)of average age in 4 loyalty status group
################################################################################

# Next, let's look at the pop_up table

# Query 7: How many consumers (column alias: consumer_count) who received a
# pop_up message (column alias: pop_up)
# continue adding discount code to their card (column alias: discount_code) 
# opposed to consumers who do not receive a pop_up message

sqldf("
     SELECT COUNT(*) AS consumer_count,
       pop_up AS pop_up, 
       saved_discount AS discount_code FROM  pop_up
       GROUP BY pop_up, saved_discount
      ")

# Interpret your output in simple English (1-2 lines):

# 4516 consumers received pop_up message and 1487 consumers can continue adding discount code to their card
# 4516 consumers neither get any pop_up message nor can continue adding discount code to their card
# 3029 consumers received pop_up message but can not continue adding discount code to their card


################################################################################

# This is purchase table

# Query 8: On an average, how much did consumers spend on their 
# total sales (column alias: total_sales) during their online purchase


sqldf("
     SELECT AVG(sales_amount_total) AS total_sales FROM purchase
      ")

# Interpret your output in simple English (1-2 lines):

#On an average,consumers spend 135.2142 on their total sales during their online purchase

################################################################################

# Finally, let's look at the email table

# Query 9: How many consumers (column alias: consumer_count) of the total opened the email blast


sqldf("
     SELECT COUNT(*) AS consumer_count,
   opened_email from email
     GROUP BY opened_email
      ")


# Interpret your output in simple English (1-2 lines):

# 716 consumers out of 9032 opened the email blast.

######################################################################################################

# Now we will combine/ merge tables to find answers

# Query 10: Was the pop-up advertisement successful? Mention yes/ no. 
# In other words, did consumers who received a pop_up message buy more

sqldf("SELECT SUM(sales_amount_total) AS sum_sales,
      AVG(sales_amount_total) AS avg_sales, 
      pop_up FROM purchase, pop_up
      WHERE purchase.consumer_id=pop_up.consumer_id 
      GROUP BY pop_up")


# Interpret your output in simple English (1-2 lines):

# No the pop up advertisement was not successful.

######################################################################################################

# Query 11) Did the consumer who spend the least during online shopping opened the pop_up message? Use nested queries.

# Write two separate queries 

# Query 11.1) Find the consumer_id who spent the least from the purchase table


sqldf("SELECT consumer_id FROM purchase 
      ORDER BY sales_amount_total LIMIT 1")

# Query 11.2) Use the consumer_id from the previous SELECT query to find if the consumer received a pop_up message from the pop_up table

sqldf("SELECT Consumer_id, pop_up FROM pop_up
      WHERE consumer_id = 5887286353")

# Query 11.3) Using ? for inner query, create a template to write nested query

sqldf("SELECT Consumer_id, pop_up FROM pop_up 
      WHERE consumer_id = (?)")

# Query 11.4) Replace ? with the inner query

# Syntax:

# SELECT consumer_id, pop_up FROM pop_up WHERE consumer_id = 
#      (SELECT consumer_id FROM purchase ORDER BY consumer_id LIMIT 1)


sqldf("SELECT Consumer_id, pop_up FROM pop_up WHERE consumer_id = 
      (SELECT consumer_id FROM purchase ORDER BY sales_amount_total LIMIT 1)
      ")


# Interpret your output in simple English (1-2 lines):

# The consumer who spent the least during online shopping did not open the pop_up message

######################################################################################################

# Query 12: Was the email blast successful? Mention yes/ no. 
# In other words, did consumers who opened the email blast buy more

sqldf("SELECT SUM(sales_amount_total) AS sum_sales, 
      AVG(sales_amount_total) AS avg_sales, 
      opened_email FROM purchase, 
      email WHERE purchase.consumer_id = email.consumer_id 
      GROUP BY opened_email")

# Interpret your output in simple English (1-2 lines):

#Yes, the email blast was successful, the consumers who opened the email bought more as 
# their average sales is higher.


######################################################################################################

# Query 13) Did the consumer who spend the most during online shopping opened the email message? Use nested queries.

# Write two separate queries 

# Query 13.1) Find the consumer_id who spent the most from the purchase table

sqldf("SELECT consumer_id FROM purchase 
      ORDER BY sales_amount_total DESC LIMIT 1")

# Query 13.2) Use the consumer_id from the previous SELECT query to find if the consumer opened the email from the email table


sqldf("SELECT * FROM email 
      WHERE consumer_id = 5955534353")

# Query 13.3) Using ? for inner query, create a template to write nested query


sqldf("SELECT consumer_id, opened_email FROM email 
      WHERE consumer_id IN(?)")

# Query 13.4) Replace ? with the inner query


sqldf("SELECT consumer_id, opened_email FROM email 
      WHERE consumer_id IN(SELECT consumer_id FROM purchase ORDER BY sales_amount_total DESC LIMIT 1)")

# Interpret your output in simple English (1-2 lines):
#Yes, the consumer who spent the most during the online shopping opened the email message.

######################################################################################################
######################################################################################################

