# ensure the results are repeatable
set.seed(7)
# load the library
library(mlbench)
library(caret)
combined_dataset <- read.csv('C:/Users/Rohil/Documents/Music_Dataset.csv')
combined_dataset$track_popularity_b[combined_dataset$track_popularity>=45]<- "1"
combined_dataset$track_popularity_b[combined_dataset$track_popularity<45]<- "0"
combined_dataset$track_popularity_b <- factor(combined_dataset$track_popularity_b)
combined_dataset$mode_b[combined_dataset$mode=='major']<- "1"
combined_dataset$mode_b[combined_dataset$mode=='minor']<- "0"
combined_dataset$mode_b <- factor(combined_dataset$mode_b)

uf <- cbind(combined_dataset$loudness, combined_dataset$energy, combined_dataset$tempo, combined_dataset$liveness,combined_dataset$danceability, combined_dataset$speechiness, combined_dataset$instrumentalness,combined_dataset$acousticness, combined_dataset$album_popularity, combined_dataset$mode_b, combined_dataset$valence)
colnames(uf)<- c("Loudness", "Energy", "Tempo","Liveness", "Danceability", "Speechiness","Instrumentalness", "Accousticness", "Album Popularity", 'Mode', 'Valence')

correlationMatrix <- cor(uf)
# summarize the correlation matrix
print(correlationMatrix)
# find attributes that are highly corrected (ideally >0.75)
highlyCorrelated <- findCorrelation(correlationMatrix, cutoff=0.65)
# print indexes of highly correlated attributes
print(highlyCorrelated)
## Removing the energy attribute because it was highly correlated and can be removed as it is a redundant feature.
uf_after_process <- cbind(combined_dataset$loudness, combined_dataset$tempo, combined_dataset$liveness,combined_dataset$danceability, combined_dataset$speechiness, combined_dataset$instrumentalness,combined_dataset$acousticness, combined_dataset$album_popularity, combined_dataset$mode_b, combined_dataset$valence)
colnames(uf_after_process)<- c("Loudness", "Tempo","Liveness", "Danceability", "Speechiness","Instrumentalness", "Accousticness", "Album Popularity", 'Mode', 'Valence')

##############################################################


### Now to find the importance of the features in relation to  the track popularity as the 
#target variable, we use a ROC curve analysis conducted for each attribute.

control <- trainControl(method="repeatedcv", number=10, repeats=3)
# train the model
model <- train(uf_after_process, y=combined_dataset$track_popularity_b, method="lvq", preProcess="scale", trControl=control)
# estimate variable importance
importance <- varImp(model, scale=FALSE)
# summarize importance
print(importance)
# plot importance
plot(importance)

##################################################################

# define the control using a random forest selection function
control <- rfeControl(functions=rfFuncs, method="cv", number=10)
# run the RFE algorithm
results <- rfe(uf_after_process, combined_dataset$track_popularity_b, sizes=c(1:10), rfeControl=control)
# summarize the results
print(results)
# list the chosen features
predictors(results)
# plot the results
plot(results, type=c("g", "o"))

