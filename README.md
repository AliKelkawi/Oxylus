# Oxylus

Oxylus is an application that allows communities at risk of wildfires to serve each other in coordination with authorities; it uses routing APIs to navigate users away from a wildfire and includes a prediction model to predict wildfires before they happen.

## 1.	Motivation:
In the past year alone, we have had wildfires in 22 countries, over 2 billion acres of land burned around the world, and over 21 thousand people displaced from their homes. These numbers are just the tip of the iceberg when discussing the impact of wildfires. These numbers inspired us to take up this challenge again, especially given the magnifying glass that the media has placed on growing wildfire rates in 2019. We have decided to enhance our previous solution to this challenge in order to tackle multiple aspects of this issue.
## 2.	Our Approach:
#### 2.1 Community Serves Community:
The Oxylus project is a multi-tier application which allows communities at risk of wildfire to serve each other as well as allow authorities to better coordinate search and rescue efforts.

By using web scraping techniques to collect data from the Incident Information System Database (InciWeb), we managed to merge reports of wildfires from users as well as real-time data of wildfires happening around the world to populate our map with up-to-date wildfire information. Users can utilize the application’s functionalities to track different wildfires and their descriptions. 
Wanting to promote a sense of community through our application, we allow our users four different types of interactions:
- __Report__: This feature allows users to report a wildfire in their vicinity. The images uploaded by the user will be verified using IBM Watson Developer Cloud to ensure validity.
-	__Guard__: This feature allows users to offer their homes as temporary shelter to people who have been displaced.
-	__Save__: This feature allows users to offer their carpool services to move people in need during evacuations.
-	__Fight__: This feature allows users to volunteer their efforts with the authorities during search and rescue missions amongst other tasks.

A user offering these services will be rewarded with small incentives in the form of badges (Pride of Oxylus, Guardian, Savior, Fighter) on their user profile for encouragement depending on how often they have offered these services to others.
A backend admin panel was also developed to enable authorities to view users registered with the application and those registered as volunteers, in order to better coordinate search and rescue efforts. Authorities can also view the locations of users who have marked themselves as in danger using the Oxylus mobile application.

## 2.2	Oxylus Serves Community
#### 2.2.1 Smart Routing:
Through a simple web search, we found that traditional routing applications such as Waze and Google Maps have had their shortcomings in directing people away from wildfires in the past. The problem became more apparent as several news articles were published regarding this issue in the past two years.
Through the use of HERE Routing API, we allow our users to select which shelter they would like to go to while directing them away from reported wildfires. Calculations are made to determine the spread of the wildfires retrieved from InciWeb based on burn area and perimeter contained to make the process of finding the shortest safe distance more accurate.

#### 2.2.2: Prediction of Wildfires
We believe the better we can predict, the better we can prevent and pre-empt. Given a set of features about a location, such as amount of vegetation, temperature, wind speed, humidity etc., we can employ machine learning algorithms that can assist us in classifying whether an area is at risk of a wildfire.
Using a dataset based on Remote Sensing preprocessed from NASA’s Land Processes Distributed Active Archive Center, comprised of approximately 1,700 datapoints of different locations in Canada, each with 3 features telling us some information about this location (Vegetation Index, Surface Temperature and Thermal Anomalies), and whether or not this location subsequently caught on fire, we  were able to train a classification model to make predictions about new data. 

#### Model:
The data was split into two parts: the training set, and the test set.
The training set was used to train our classification model using a Random Forest Classifier. With the prediction model that was developed, the test set was used to validate its accuracy. Out of 343 test points, the following results were gathered:
•	286 correct predictions were made (True positives and true negatives).
•	46 points were incorrectly identified as fires (False positives)
•	11 points were incorrectly identified as non-fires (False negatives)
These results translate to an accuracy of 84%, a precision of 83% and a recall of 96%.
Simply put, the developed classification model was able to correctly classify a location as low or high risk 4 times out of 5 with the given data. 

#### Simulation:
To help visualize how the data will be received and transmitted mid-forests, we simulated a scenario of a Wireless Sensor Network using CupCarbon simulator, with sensor nodes collecting data and transmitting them to a base station for analysis with the classification model, the integration of which would hopefully be something to look forward to in the near future.

## 3.	Future Plans:
The vision of Oxylus has the potential of extending beyond what was described in the functionalities above. Some of the functionalities that can be implemented in the future are:
-	Using data from NASA’s satellites as well as user reported data, we can build efficient evacuation plans for emergency situations.
-	The classification model can be extended to other natural disasters such as tsunamis and earthquakes.
-	Routing plans can be devised for emergency personnel to direct them to the location of a wildfire by avoiding areas of congestion.
-	A Wireless Sensor Network can be deployed in different locations to collect more data for training classification models.

## 4.	Resources Used:
-	Real-time wildfire data from InciWeb (https://inciweb.nwcg.gov/)
-	Wildfire Prediction Dataset - DOI: http://dx.doi.org/10.17632/85t28npyv7.1#file-a915aa98-7b0b-4446-94fb-9a7572e2d8f2

## 5.	Tools Used:
-	Xcode IDE + Swift programming language
-	Spyder IDE + Python programming language
-	Netbeans IDE + Java programming language
-	Firebase
-	HERE Routing API
-	IBM Watson Developer Cloud
-	Node.js
-	CupCarbon simulator – A Smart City & IoT Wireless Sensor Network Simulator (http://cupcarbon.com/)
-	Adobe Illustrator
-	Web Scraping extension (https://webscraper.io/)

## 6.	Team:
-	Ali Kelkawi (Computer Science Teaching Assistant)
-	Shahad Al-Mousa (Risk Management Analyst)
-	Zeid Malas (PR & Marketing Coordinator)
-	Abdulaziz Karam (Computer Science Senior Student)
-	Abdulhameed Salama (Computer Science Senior Student)
-	Abdulwahab Al-Saleh (Computer Science Junior Student)
-	Jiyoung Moon (High school Student)
