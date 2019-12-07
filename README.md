# behavior
Creating a behavioral timeline on Twitter using R and the Twitter API.

### Why?
In the wake of present day Surveillance Capitalism giants such as Google and Facebook, every aspect of your information and behavior is being not only monitored, but studied intensly for the sole purpose of profit.  However, the most jarring and disturbing continuation of this future does not stop at simple advertisements, but rather behavioral tweaking and modifying in order to influence the consumer to purchase, act, and think in certain ways.

During this project I decided to create a more simplified version of the information analysis that goes on behind the scenes at all of these companies.  No individual matters here, only the group collective mind is important and is used as the basis of persuading and influencing others into that same line of thinking.  With that in mind, the Twitter behavioral timeline sets out to instill in the viewer a brief glimpse of the power behind information and the importance of privacy in present day times.

### Code and System Requirements
The R script used requires a few different libraries to be run successfully, those are:

* TwitteR
* ROAuth
* tm
* wordcloud
* tidyverse
* tidytext
* ggpubr
* textdata
* dplyr

Additionally, due to the quantity of tweets being grabbed from Twitter at each time of running, you must have at least 2GB free of RAM for the script to work properly.

When it comes to the actual running of the script every 30 minutes, you need to set up a cronjob.  You can do this by either installing the package into RStudio if you are using a gui or you can do it through the command line with _crontab -e._

The following crontab will run the R script every 30 minutes -

* https://crontab.guru/every-half-hour (path of RScript compiler) (Path of R file)

### Documentation of the project

You can find a live version at my website by clicking ![HERE](http://lukelabenski.com/behavior).  Otherwise, you can view some screen shots and a short video of the project below.

![00:00](https://i.imgur.com/61vCKRd.png)


***

![13:00](https://i.imgur.com/uoApK9Y.png)

***

https://youtu.be/WfnyYI0rl1Q

