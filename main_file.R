# ensure the results are repeatable
set.seed(7)
# load the library
library(mlbench)
library(caret)
combined_dataset <- read.csv('C:/Users/Rohil/Documents/Music_Dataset.csv')
combined_dataset$valence_b[combined_dataset$valence>=0.50]<- "1"
combined_dataset$valence_b[combined_dataset$valence<0.50]<- "0"
combined_dataset$valence_b <- factor(combined_dataset$valence_b)
combined_dataset$mode_b[combined_dataset$mode=='major']<- "1"
combined_dataset$mode_b[combined_dataset$mode=='minor']<- "0"
combined_dataset$mode_b <- factor(combined_dataset$mode_b)

usefull_features <- cbind(combined_dataset$loudness, combined_dataset$energy, combined_dataset$tempo, combined_dataset$liveness,combined_dataset$danceability, combined_dataset$speechiness, combined_dataset$instrumentalness,combined_dataset$acousticness, combined_dataset$track_popularity, combined_dataset$album_popularity, combined_dataset$mode_b)
colnames(usefull_features)<- c("Loudness", "Energy", "Tempo","Liveness", "Danceability", "Speechiness","Instrumentalness", "Accousticness", "Track_Popularity", "Album Popularity", 'Mode')



##----------------------Removing Redundant Features##############_________

# calculate correlation matrix
correlationMatrix <- cor(usefull_features)
# summarize the correlation matrix
print(correlationMatrix)
# find attributes that are highly corrected (ideally >0.75)
highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.75)
# print indexes of highly correlated attributes
print(highlyCorrelated)
usefull_features_after_process <- cbind(combined_dataset$loudness, combined_dataset$energy, combined_dataset$tempo, combined_dataset$liveness,combined_dataset$danceability, combined_dataset$speechiness, combined_dataset$instrumentalness,combined_dataset$acousticness, combined_dataset$album_popularity, combined_dataset$mode_b)
colnames(usefull_features_after_process)<- c("Loudness", "Energy", "Tempo","Liveness", "Danceability", "Speechiness","Instrumentalness", "Accousticness", "Album Popularity", 'Mode')
#######_______ According to above method Track Popularity is highly correlated,So
## it is redundant variable and it is removed from the dataset.



### Now to find the importance of the features in relation to  the valence as the 
#target variable, we use a ROC curve analysis conducted for each attribute.

control <- trainControl(method="repeatedcv", number=10, repeats=3)
# train the model
model <- train(usefull_features_after_process, y=combined_dataset$valence_b, method="lvq", preProcess="scale", trControl=control)
# estimate variable importance
importance <- varImp(model, scale=FALSE)
# summarize importance
print(importance)
# plot importance
plot(importance)


#### I also used the random forest technique to  find the importance of the each feature.

# define the control using a random forest selection function
control <- rfeControl(functions=rfFuncs, method="cv", number=10)
# run the RFE algorithm
results <- rfe(usefull_features_after_process, combined_dataset$valence_b, sizes=c(1:10), rfeControl=control)
# summarize the results
print(results)
# list the chosen features
predictors(results)
# plot the results
plot(results, type=c("g", "o"))
