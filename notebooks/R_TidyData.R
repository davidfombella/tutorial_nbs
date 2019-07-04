

# Read CSV into R
df <- read.csv(file="../data/pass_stats.csv", header=TRUE, sep=",")

head(df)

summary(df)


# Computing the mean long pass accuracy for all players

mean(df$longPassesAccPC)


# Filter for goalkeepers
df_gk <- df[df$position=='gk',]



# Filter for outfield players
df_of <- df[df$position!='gk',]

# Compute the mean long pass accuracy for goalkeepers
gk_lpa <- mean(df_gk$longPassesAccPC)
gk_lpa

# Compute the mean long pass accuracy for outfield players
of_lpa <- mean(df_of$longPassesAccPC)
of_lpa


# So the average long pass accuracy for a goalkeeper is better than for an outfield player. 
# This may not be an exciting result but it's not bad for a few lines of code.



# We can also sort the data by the values in the different columns. 
# Note that this does not result in df being sorted after it is called, 
# instead it returns a new dataframe that is a sorted version of df.

head (  df[order(df$longPassesP90,decreasing = TRUE),])




# Player 588 at team 89 tops the ranking for long passes p90, but his accuracy (39%) is well below average.

# Finally, in Tidy Format we can combine columns quickly to compute new statistics. 
# For example, in this dataset every pass is characterised as
# either short or long so we can compute the total passes p90 by adding the two columns together.





# Create a new column as the sum of two others

df$passesP90 <- df$shortPassesP90 + df$longPassesP90


# View team, position and passesP90 for the first 5 rows of the table

head (  df[,c("teamId","position","passesP90")]   ,5)




library(ggplot2)
# Tidy data in Seaborn

##ggplot can quickly create graphics such as scatterplots, histograms and density plots 
# by providing a dataframe and the associated column names for the values to plot. 
# For example, we can check the relationship between short passes p90 and long passes p90 with a single line of code.

#Produces a scatter plot of the 'shortPassesP90' columns against the 'longPassesP90' in df

ggplot(df, aes(shortPassesP90, longPassesP90))+
  geom_point()


# Additional properties for plot can be associated with different columns of the dataframe. 
# For example, we can highlight goalkeepers in the above scatterplot by setting a different marker.

# create new is_gk true false variable

df$is_gk <- df$position == "gk"

ggplot(df, aes(shortPassesP90, longPassesP90, colour=is_gk))+
  geom_point()


######################
## violin
## long Passes % Acc
#####################

ggplot(df, aes(is_gk,longPassesAccPC, fill=is_gk))+
  geom_violin()











# This works well for the goalkeepers but it looks like there's too
# many outfield players to really get a sense for the distribution as 
# they bunch up and overlap along the left and right. 
# In this case, it might be better to use a violinplot which gives a 
# density estimate instead of plotting all of the points. 
# Fortunately, changing between swamplots, violinplots and boxplots 
# is as easy as changing one line of code (see below).


# For example, we can specify the size, alter the axis labels or add custom elements to the plot.

# Below we build a more complex graphic showing how a given player's pass accuracy compares 
#  to others by combining violinplots, swarmplots and matplotlib plotting. 






#First we extract the data on a given player of interest 
#Data for the player with id 2085
p_interest =  df[df$playerId==2085,]


spa <- p_interest$shortPassesAccPC

lpa <- p_interest$longPassesAccPC

fpa <- p_interest$forwardPassesAccPC


ggplot(df, aes(x='shortPasses', y=shortPassesAccPC))+
  geom_violin()+
  geom_point(data =  df[df$playerId==2085,],colour='red',size=3)


ggplot(df, aes(x='Forward Passing', y=forwardPassesAccPC))+
  geom_violin()+
  geom_point(data =  df[df$playerId==2085,],colour='red',size=3)


ggplot(df, aes(x='Long Passing', y=longPassesAccPC))+
  geom_violin()+
  geom_point(data =  df[df$playerId==2085,],colour='red',size=3)+
  geom_hline(yintercept=range(89), color='blue', size=1)