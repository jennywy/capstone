Capstone Project - Back End 

## Summary
"Call me, baby" is an appointment reminder SPA that uses a Rails API that integrates with Twilio to send SMS a set interval before a user's schedule appointment. This capstone project is adapted from Twilio's appointment reminder project found here: ((https://www.twilio.com/docs/tutorials/appointment-reminders-ruby-rails)). I adapted it to send a custom message set by the client instead of the hardcoded message reminder.
The user creates a message on the front end, and using the rails active record callback, after_create, the Twilio SMS request is constructed and sent to Twilio.
Using an Active Jobs Queue adapter, delayed_job, we're able to call the method handle_asynchronously which allows for a delayed firing of the SMS message to a chosen time.
CMB requires users to be authenticated in order to use the site and CRUD appointments. Alas, the poor author is on a Twilio free trial account meaning messages can only be sent to the author's cell phone so it doesn't matter.

## ERD
((https://i.imgur.com/xp7V4Zu.png))

## Unsolved Back End Problems
- Updating and deleting an appointment message body or time does not currently ping Twilio to update or delete that SMS. Twilio does support PUT and DELETE requests with their API, and needs the take the argument of the Twilio generated message ID (SID) in order to complete the request.
- At the moment the appointment reminder time is hardcoded to be 1 minute before the appointment (for the purposes of demoing, but realistically should be like an hour before). I'd like to impliment a feature that allows the user to choose how early they'd like to be reminded - an hour before, 30 minutes before, etc...
- The Time Zone is hard coded to EST in the config file and doesn't dynamically take the users time zone. I'm not totally sure how to test that since it's only texting me and I am only ever on the (B)East Coast and couldn't totally understand the ActiveSupport documentation for time zones, but it was better than pinging to me in Zulu/GMT time.

## Technologies Used
- Rails API
- Twilio API
- twilio gem
- delayed_job Active Job Queue Adapter
- daemons to start delayed_job
- Heroku

## API

| Verb   | URI Pattern         | Controller#Action        |
|:-------|:--------------------|:-------------------------|
| GET    | `/appointments`     | `appointments#index`     |
| GET    | `/appointments/:id` | `appointments#show`      |
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
