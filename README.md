# Predicting emotional reactions to Facebook posts by political actors

## Introduction

Emotions play a central role in social life, of which politics is no exception. Political science research has investigated systematic effects of emotions on politically relevant behavior such as turnout, vote choice, information search, and public attitudes.

Especially on social media, emotions are important, e.g. because false news on Twitter spread faster than true news, possibly because of invoked emotional responses. There is also evidence of emotional contagion on Facebook, shown by the observation that users exposed to fewer positive posts tend to produce fewer positive posts themselves. At the same time, social media provide political actors with unprecedented means to communicate directly to large audiences. Still, we know relatively little about the effects of emotional communication by political actors and its strategic use.

## Research question

Against this background, I investigate emotional reactions to social media posts from political actors. More specifically, I ask: Which characteristics explain the amount of specific emotional reactions a post gets?

Substantively, I argue that a systematic link between political communication and reactions to it is a necessary condition for political communication to be used strategically.

I expect that sentiment in posts by political actors affect user's emotional reactions to these posts. The research question of this study closely follows a recent study by @eberl2020what. Using data from Austrian political actors during the 2017 Austrian election, they find that the sentiment of a Facebook post relates to the number of "Love" and "Angry" reactions to that post.

I build on this study, but go beyond it in several aspects. First, I analyze data from Germany and will extend the timeframe to a complete legislative cycle instead of one election campaign. Second, my empirical approach is different because I apply an exploratory approach based on machine learning, instead of formulating hypotheses in a confirmatory framework. The focus is thus on predicting $\hat{Y}$ (reactions) instead of quantifying the contribution from one individual $\hat{\beta_i}*X_i$. Such an approach is kind of new for political science but clearly on the rise.

While the focus is on prediction, I will also evaluate the effects of substantively interesting factors, i.e., evaluate their contribution for predicting the outcome.

## Data & Measurement

I use data on Facebook posts by political actors obtained via CrowdTangle. CrowdTangle is a public insights tool, whose main intent was to monitor what content overperformed in terms of interactions (likes, shares, etc.) on Facebook and other social media platforms. In 2016, CrowdTangle was acquired by Facebook that now provides the service.

After receiving individual access for scientific purposes, CrowdTangle offers extensive functionality to download Facebook posts and related metadata from public pages, such as verified official pages or individual accounts with large numbers of followers. The availability of the data goes back until the very start of Facebook and thus offers a large amount of data. Besides the textual post content, the data also contains account information, and -- crucially for this project -- the number of interactions with the post (for a codebook see @garmur2019crowdtangle). These interactions include the number of likes, shares and comments. 

Since 2016, Facebook offers a set of distinct reactions to posts expressed by emojis, which may be interpreted as emotional reactions ("Love", "Angry", "Haha", "Wow", "Sad", "Care"). While some of these are quite ambiguous, recent research has used the "Love" and "Angry" reactions as proxies for the respective emotional response.


For now, I will restrict the analysis to Germany, but in principle, the approach will be scalable to other cases as well, since Facebook coverage is wide and behavior on the platform can be analyzed using a common metric.

For the first step, I will also restrict the analysis to posts from party accounts, as this already presents a large data source without the need to identify all relevant accounts from individual political candidates. In the next step, however, I will include all posts from individual candidates, which will then represent a more complex, nested data structure (posts nested within accounts, nested within parties).


## Estimation strategy
I intend to build a machine learning model predicting emotional reactions to Facebook posts. As outcome measure I will either use the number of "Love" /"Angry" reactions or its share on all reactions.

As inputs, I intend to use three broad types of input: (i) metadata about the post as obtained from CrowdTangle, (ii) data derived from the message text, such as sentiment or topic, and (iii) external data from the information environment such as public issue salience, economic conditions, opinion polls, or time until election day.

The exact model specifications are yet to be defined. Model performance will be investigated on test data, which will be left untouched during the model training phase.

## Author
- [Pirmin Stöckle](https://gess.uni-mannheim.de/doctoral-programs/social-and-behavioral-sciences-cdss/students/people/show/pirmin-stoeckle.html) (SFB 884 & CDSS; University of Mannheim)
