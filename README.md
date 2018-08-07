# YahooFantasyAPI
This R package contains functions for using the Yahoo FantasySports API. In order to use the API, you'll need to go through a few steps for setting up your Yahoo account & app as well as specifying which permissions your app will have. Creating an app is necessary for getting your key and secret which have to be used for accessing the API.

### Creating an App
To create an app, you'll need to head to the [Yahoo Developer site](https://developer.yahoo.com/ "Yahoo Developer Network") and sign in to your Yahoo account. Once signed in, you can hover over the "My Apps" menu item in the top right and click on "YDN Apps", or visit <https://developer.yahoo.com/apps/>.

From there, click "Create an App" which will take you to a new page with a form to fill out with info about your app. Name the app whatever you prefer, the name will not be used in using the API, so it doesn't matter what you name it. Under 'Application Type' make sure you check the Installed Application button. This is very important as leaving it as a Web Application will alter the authorization flow such that R cannot use it.

Ignore the Description, Home Page URL, and Callback Domain boxes.

Under 'API Permissions', click on 'Fantasy Sports' and then check the 'Read/Write' permissions checkbox. This will give your app permissions to access the Yahoo Fantasy Leagues associated with your Yahoo account. From there click on 'Create App' and it should take you to a new page that shows the information for your new app. There are two pieces of information you'll need from this page to use the API: the Client Key and the Client Secret. These should be two long jumbles of letters and numbers.

Every time you start a new R session and want to use the API, you'll need to request a token using the Key and Secret, so it's probably a good idea to save these somewhere locally on your computer to save time. The Key and Secret associated with your app won't change, so if you do save them on your computer you won't have to worry about needing to update your file. (Note: when copying the key and secret from the Yahoo page be careful of it adding leading spaces to the text selection upon pasting it elsewhere)

### Using the R package
Whenever starting a new R session, you'll always need to run the `get_token` command, passing in your key and secret. This function handles the authorization and access tokens needed to use the API. When running this function, it will open up a page through your default internet browser that will require you to login to your Yahoo account and grant access to the R function. After clicking 'Agree' on the prompt page, you will be given a 7 character code to copy and paste back into the R console at the prompt. The `get_token` function will then retrieve the necessary tokens and store them in a locked R environment. This new environment will allow the other functions to easily access the tokens without the user having to continuously pass tokens back and forth from function to function.

The next step is to figure out your game id. This is year- and sport-specific, and can be found from running the `get_this_year_game_info` function and passing in one of `'nfl','mlb','nba','nhl'`. This function will return a data.frame with info on this year's info about the fantasy sport you specified. The important value to use from this is the `game_id` column. This lets Yahoo know which sport and year you are requesting in subsequent API calls. 

Next you'll need to log into your Yahoo Fantasy account and go to your league. The link should look something like this "https://football.fantasysports.yahoo.com/f1/121038/10". The numbers "121038" represent the league id. Those numbers are for my league, yours will be different and you'll need to get yours and keep it handy.

Once you have the gameid and leagueid, you can pass those as parameters to the `get_league_info`, `get_league_standings`, and `get_player_list`functions. 

`get_league_info` returns basic information about your fantasy league such as the name, draft status, number of teams, etc.

`get_league_standings` returns the wins, losses, points for, and points against for all the teams in the league. 

`get_player_list` returns the Yahoo default player rankings from your league.
