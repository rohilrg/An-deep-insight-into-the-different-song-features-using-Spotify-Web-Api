md <- combined_dataset
cor_valence <- cbind(combined_dataset$loudness, combined_dataset$energy, combined_dataset$tempo, combined_dataset$liveness,combined_dataset$danceability, combined_dataset$speechiness, combined_dataset$instrumentalness,combined_dataset$acousticness, combined_dataset$track_popularity, combined_dataset$album_popularity)
colnames(cor_valence)<- c("Loudness", "Energy", "Tempo","Liveness", "Danceability", "Speechiness","Instrumentalness", "Accousticness", "Track Popularity", "Album Popularity")
m<- cor(combined_dataset$valence, cor_valence)
m

barplot(m, axes = TRUE, beside = TRUE)

#According to the correlation plot shows Danceablity> Energy> Loudness> Tempo> Speechiness
#with Valence.So these attributes can be used to predict the right music for a given track with most coherent valence with song.

most_cor_attributes <- cbind(combined_dataset$artist_name,combined_dataset$loudness, combined_dataset$energy, combined_dataset$tempo, combined_dataset$danceability, combined_dataset$speechiness, combined_dataset$valence)
colnames(most_cor_attributes) <- c("Artist Name","Loudness", "Energy", "Tempo", "Danceability", "Speechiness", "Valence")

library(h2o)
