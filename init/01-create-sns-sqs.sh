#!/bin/bash

# ----------------------------
# 1. Create SNS topics
# ----------------------------

# Create a topic for when a user is created
awslocal sns create-topic --name UserCreated

# Create a topic for when a user follows another user
awslocal sns create-topic --name UserFollowed

# Create a topic for when a user unfollows another user
awslocal sns create-topic --name UserUnfollowed

# Create a topic for when a post is created
awslocal sns create-topic --name PostCreated

# Create a topic for when a post is deleted
awslocal sns create-topic --name PostDeleted

# Create a topic for when a post is liked
awslocal sns create-topic --name PostLiked

# Create a topic for when a post is unliked
awslocal sns create-topic --name PostUnliked


# ----------------------------
# 2. Create SQS queues
# ----------------------------

# Create a queue to receive messages for UserCreated topic
awslocal sqs create-queue --queue-name UserCreatedQueue

# Create a queue to receive messages for UserFollowed topic
awslocal sqs create-queue --queue-name UserFollowedQueue

# Create a queue to receive messages for UserUnfollowed topic
awslocal sqs create-queue --queue-name UserUnfollowedQueue

# Create a queue to receive messages for PostCreated topic
awslocal sqs create-queue --queue-name PostCreatedQueue

# Create a queue to receive messages for PostDeleted topic
awslocal sqs create-queue --queue-name PostDeletedQueue

# Create a queue to receive messages for PostLiked topic
awslocal sqs create-queue --queue-name PostLikedQueue

# Create a queue to receive messages for PostUnliked topic
awslocal sqs create-queue --queue-name PostUnlikedQueue


# ----------------------------
# 3. Attach queues to topics
# ----------------------------

# Arrays to store all topics and their corresponding queues
TOPICS=("UserCreated" "UserFollowed" "UserUnfollowed" "PostCreated" "PostDeleted" "PostLiked" "PostUnliked")
QUEUES=("UserCreatedQueue" "UserFollowedQueue" "UserUnfollowedQueue" "PostCreatedQueue" "PostDeletedQueue" "PostLikedQueue" "PostUnlikedQueue")

# Loop through each topic and subscribe its corresponding queue
for i in "${!TOPICS[@]}"; do
  # Get the URL of the SQS queue
  QUEUE_URL=$(awslocal sqs get-queue-url --queue-name ${QUEUES[$i]} --output text)

  # Get the ARN (Amazon Resource Name) of the SNS topic
  TOPIC_ARN=$(awslocal sns list-topics | grep ${TOPICS[$i]} | awk -F'"' '{print $4}')

  # Subscribe the SQS queue to the SNS topic so it receives messages
  awslocal sns subscribe --topic-arn $TOPIC_ARN --protocol sqs --notification-endpoint $QUEUE_URL
done