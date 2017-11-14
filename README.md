<h1>Call Me, Baby - WDI Full Stack Capstone Project - Back End Repo </h1>

## Summary
"Call me, baby" is an appointment reminder single page application that uses a Rails API that integrates with Twilio to send SMS a set interval before a user's schedule appointment. This capstone project is adapted from Twilio's appointment reminder project found [here](https://www.twilio.com/docs/tutorials/appointment-reminders-ruby-rails). I adapted it to send a custom message set by the client instead of the static message reminder as in their example that the client enters in forms on the front end.

The user creates a message on the front end, and using the Rails Active Record Callback, after_create, the Twilio SMS request is constructed and sent to Twilio.

Using an Active Jobs Queue adapter, delayed_job, we're able to call the method handle_asynchronously which allows for a delayed firing of the SMS message to a chosen time.
CMB requires users to be authenticated in order to use the site and CRUD appointments. Alas, the poor author is on a Twilio free trial account meaning messages can only be sent to the author's cell phone so it doesn't matter.

## Back End Repository
https://github.com/jennywy/capstone

## Back End Deployed
https://tranquil-caverns-61326.herokuapp.com/appointments

## Front End Repository
https://github.com/jennywy/callmebby

## Front End Deployed
https://jennywy.github.io/callmebby/

## ERD
![Entity Relationship Diagram](https://i.imgur.com/xp7V4Zu.png)

## Wireframe
![Wireframe](https://i.imgur.com/aJX5mSK.png)

## Project
![Call Me Baby](https://i.imgur.com/o6aMh3r.png)

## User Stories
- As a user I want to set an appointment with an appointment name so I know what appointments I have
- As a user I want to set an appointment with an appointment time so I can make my appointment on time
- As a user I want to enter a phone number so I can receive SMS alerts to be reminded about my appointment
- As a user I want to be sent an SMS to my phone number to be reminded about my appointment 30 minutes before my appointments
- As a user I want to set a custom SMS to be reminded with specific details about my appointment

## Planning Process
I wanted take on challenges in areas I knew I was weak in, namely reading documentation and being able to articulate my problems to troubleshoot issues. I wanted to solve my own problems as much as possible and choose a project that was somewhat outside the scope of the course, but not impossible to do. I was really ill with pneumonia and unfortunately lost a lot of time on this project so I didn't get as far as I wanted to, but I'm pretty happy with how far I got on the back-end and learned a lot about myself as a developer.

I chose this project because I wanted to use a third party API. I found this Twilio project, and wanted to break it down to really understand how it works, and see if I could make it better. I did that by adapting the project to not use the Rails view layer as suggested in the Twilio project and instead splitting the front-end as we'd learned to do in class. I added user authentication via a protected_controller that required a token for all CRUD actions on the appointments. I am also storing and sending a custom SMS message vs in Twilio's example where they have a static message for every appointment.

This project was really challenging because third party API integration is not something explicitly covered in the course, and neither were Rails Active Jobs. In class we had briefly discusses how methods could be written in the resource model, but we had never really seen what could be done. Even doing little things like figuring out how to set up the environment variables for Twilio took me a long time to do at first, not because it was difficult, but because I got lost in the vastness of Twilio's documentation for every use case.

Many of the challenges I had were figuring out how the ruby gems required for Twilio and delayed sending worked and what they needed in order to be set up correctly which required finding out what Active Jobs were, how to fire them, and other things how to access the Procfile, and find documentation to set up Time Zones in the Application.rb, which were all totally unfamiliar to me. Finding out how to start the delayed_jobs gem locally, and then in production with Heroku were the biggest time sucks even through they required me running one simple command.

Overall it was an incredible journey of self-discovery. I felt obliged to read every piece of the Twilio documentation before I had to start and do their version of CodeSchool and talk to their support representatives, and that ended up not being the best use of my time. I did learn that my instincts to start just writing code and seeing what happens is something I should nurture. I made way more progress in my understanding and in my project than from just reading.

I've also learned that I really enjoy back-end development more than front-end. The more I read about Active Record, the more it sparked my curiosity and inspired a desire to learn and experiment with Active Record callbacks to see how else they can be used.

I had pneumonia and spent most of my time working on my back end that I had neglected the front end! I really wanted to do this project in Ember, but I didn't feel confident with the framework after a week of mostly self-directed learning while I was ill on top of doing a kind of tricky third party API integration with Active Jobs so I scrapped the idea and used the browser template that GA built for us kind of as a crutch.

I identified lots of ways I want to grow in the future:
- I definitely have learned to appreciate the Agile development process to making sure I'm on time, working on the right things at the right time, and not spending too much time on the wrong things because I did everything wrong for this capstone project!
- Planning and design are not at all my strong suits and I'd like to grow in these areas very much! I don't have good intuition for how to come up with a great layout for a website that does X, Y, and Z and how to represent that data in the most inuitive, and aesthetically pleasing way, but I want to learn how to plan better and make good wireframes, and make my websites look like my wireframes!
- My commit history is a mess! I definitely worked on the master branch too often and not on a feature to development to master like I should have.

## Unsolved Back End Problems
- Updating and deleting an appointment message body or time does not currently ping Twilio to update or delete that SMS. Twilio does support PUT and DELETE requests with their API, and needs the take the argument of the Twilio generated message ID (SID) in order to complete the request. I'm not yet sure when the SID generates if I'm able to capture it to update it with the way it goes to the job queue to fire after_create, and it will require reading a little more documentation experimentation to see if it is possible.
- At the moment the appointment reminder time is hardcoded to be 1 minute before the appointment (for the purposes of demoing, but realistically should be like an hour before). I'd like to impliment a feature that allows the user to choose how early they'd like to be reminded - an hour before, 30 minutes before, etc...
- The Time Zone is hard coded to EST in the config file and doesn't dynamically take the users time zone. I'm not totally sure how to test that since it's only texting me and I am only ever on the (B)East Coast and couldn't totally understand the ActiveSupport documentation for time zones, but it was better than pinging to me in Zulu/GMT time.

## Technologies Used
- Rails API
- PostgreSQL
- Twilio API
- twilio gem
- delayed_job Active Job Queue Adapter
- daemons to start delayed_job
- Heroku

## API

| Verb   | URI Pattern         | Controller#Action        |
|:-------|:--------------------|:-------------------------|
| GET    | `/appointments`     | `appointments#index`     |
| POST   | `/appointments`     | `appointments#create`    |
| PATCH  | `/appointments/:id` | `appointments#update`    |
| DELETE | `/appointments/:id` | `appointments#destroy`   |

### Authentication

| Verb   | URI Pattern            | Controller#Action |
|--------|------------------------|-------------------|
| POST   | `/sign-up`             | `users#signup`    |
| POST   | `/sign-in`             | `users#signin`    |
| PATCH  | `/change-password/:id` | `users#changepw`  |
| DELETE | `/sign-out/:id`        | `users#signout`   |

#### POST /sign-up

Request:

```sh
curl http://localhost:4741/sign-up \
  --include \
  --request POST \
  --header "Content-Type: application/json" \
  --data '{
    "credentials": {
      "email": "'"${EMAIL}"'",
      "password": "'"${PASSWORD}"'",
      "password_confirmation": "'"${PASSWORD}"'"
    }
  }'
```

```sh
EMAIL=ava@bob.com PASSWORD=hannah scripts/sign-up.sh
```

Response:

```md
HTTP/1.1 201 Created
Content-Type: application/json; charset=utf-8

{
  "user": {
    "id": 1,
    "email": "ava@bob.com"
  }
}
```

#### POST /sign-in

Request:

```sh
curl http://localhost:4741/sign-in \
  --include \
  --request POST \
  --header "Content-Type: application/json" \
  --data '{
    "credentials": {
      "email": "'"${EMAIL}"'",
      "password": "'"${PASSWORD}"'"
    }
  }'
```

```sh
EMAIL=ava@bob.com PASSWORD=hannah scripts/sign-in.sh
```

Response:

```md
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{
  "user": {
    "id": 1,
    "email": "ava@bob.com",
    "token": "BAhJIiVlZDIwZTMzMzQzODg5NTBmYjZlNjRlZDZlNzYxYzU2ZAY6BkVG--7e7f77f974edcf5e4887b56918f34cd9fe293b9f"
  }
}
```

#### PATCH /change-password/:id

Request:

```sh
curl --include --request PATCH "http://localhost:4741/change-password/$ID" \
  --header "Authorization: Token token=$TOKEN" \
  --header "Content-Type: application/json" \
  --data '{
    "passwords": {
      "old": "'"${OLDPW}"'",
      "new": "'"${NEWPW}"'"
    }
  }'
```

```sh
ID=1 OLDPW=hannah NEWPW=elle TOKEN=BAhJIiVlZDIwZTMzMzQzODg5NTBmYjZlNjRlZDZlNzYxYzU2ZAY6BkVG--7e7f77f974edcf5e4887b56918f34cd9fe293b9f scripts/change-password.sh
```

Response:

```md
HTTP/1.1 204 No Content
```

#### DELETE /sign-out/:id

Request:

```sh
curl http://localhost:4741/sign-out/$ID \
  --include \
  --request DELETE \
  --header "Authorization: Token token=$TOKEN"
```

```sh
ID=1 TOKEN=BAhJIiVlZDIwZTMzMzQzODg5NTBmYjZlNjRlZDZlNzYxYzU2ZAY6BkVG--7e7f77f974edcf5e4887b56918f34cd9fe293b9f scripts/sign-out.sh
```

Response:

```md
HTTP/1.1 204 No Content
```

### Users

| Verb | URI Pattern | Controller#Action |
|------|-------------|-------------------|
| GET  | `/users`    | `users#index`     |
| GET  | `/users/1`  | `users#show`      |

#### GET /users

Request:

```sh
curl http://localhost:4741/users \
  --include \
  --request GET \
  --header "Authorization: Token token=$TOKEN"
```

```sh
TOKEN=BAhJIiVlZDIwZTMzMzQzODg5NTBmYjZlNjRlZDZlNzYxYzU2ZAY6BkVG--7e7f77f974edcf5e4887b56918f34cd9fe293b9f scripts/users.sh
```

Response:

```md
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{
  "users": [
    {
      "id": 2,
      "email": "bob@ava.com"
    },
    {
      "id": 1,
      "email": "ava@bob.com"
    }
  ]
}
```

#### GET /users/:id

Request:

```sh
curl --include --request GET http://localhost:4741/users/$ID \
  --header "Authorization: Token token=$TOKEN"
```

```sh
ID=2 TOKEN=BAhJIiVlZDIwZTMzMzQzODg5NTBmYjZlNjRlZDZlNzYxYzU2ZAY6BkVG--7e7f77f974edcf5e4887b56918f34cd9fe293b9f scripts/user.sh
```

Response:

```md
HTTP/1.1 200 OK
Content-Type: application/json; charset=utf-8

{
  "user": {
    "id": 2,
    "email": "bob@ava.com"
  }
}
```
