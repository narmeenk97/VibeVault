/*
### VibeVault Documentation ###

--- What each file does in the lib folder? ---

## main.dart - this is where everything is tied together, this is the main point of entry into the application.
Currently, this is where I plan to have the logo for the app and then it redirects you to the dashboard.
## dashboard.dart - this is the homepage of the app, currently its supposed to show today's date and a button that takes you
to the mood_entry page. Right under that there is a container with the previous days mood data, if there was no data from the
previous day then it should display an appropriate message like "No mood data logged"

## mood_entry.dart - this is main event of the app. This is where the user will actually log their mood data. I want there to be
sliders for each mood on a scale of 1-5 with small descriptions of each number of the scale to describe what that number means.
There will be a total of 7 moods that are tracked: Calm, Happy, Energetic, Apathetic, Irritated, Anxious, Depressed.
There will also be textboxes where the user can leave notes regarding their choice on the scale for each mood, these notes
can be used later on in the analysis.

## analysis.dart - Currently I am still figuring out what I exactly want for the analysis. I want to display the trends for the
user over a period of time like a week, year, or month. I want to display their best day and their worst day. In the future,
I could use AI to analyze the mood data and give a detailed mood analysis to the user. This will just be informative and not
to be taken as professional advice. It will just be data analysis.
 */