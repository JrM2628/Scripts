import json
import os
import groupme
import string
import argparse


def print_stats():
    print("-----------------------------------------")
    print("Final Statistics:")
    print("Time elapsed: ")
    print("Top 50 favorite words: ")
    print("Most talkative: ")
    print("Most likable: ")
    print("Most liking: ")
    print("Media sender: ")
    print("Most times kicked: ")
    print("Longest lasting group name: x @ y days")


def print_shell_msg():
    print("1. Print final statistics")
    print("2. Clear screen")
    print("3. Word count")
    print("4. Print message details by number")
    print("5. Print user details")
    print("5. Exit")
    input("Make your selection: ")


def load_file(file_name):
    try:
        with open(file_name, "r", encoding="utf8") as read:
            data = json.load(read)
        return data
    except FileNotFoundError:
        print("Error loading file")
        exit()


def main():



    temp_file = "C:\\Users\\shell\\Documents\\groupme\\3\\*\\message.json"
    data = load_file(temp_file)
    group = groupme.Group(data[0]['group_id'], data)

    d = dict.fromkeys(string.ascii_lowercase, 0)
    b_count = 0

    for msg in data:
        if 'text' in msg and msg['text'] is not None:

            for letter in msg['text'].lower():
                if letter in d:
                    d[letter] += 1

            if msg['text'].lower() in group.unique_messages:
                group.unique_messages[msg['text'].lower()] += 1
            else:
                group.unique_messages[msg['text'].lower()] = 1

        if msg['system'] and 'event' in msg:
            event_type = msg['event']['type']

            if event_type == 'group.avatar_change':
                group.group_avatars[msg['event']['data']['avatar_url']] = msg['created_at']
            elif event_type == 'group.name_change':
                name = msg['event']['data']['name']
                if name not in group.group_names:
                    group.group_names[name] = msg['created_at']
            elif event_type == 'membership.announce.added':
                z = 0
            elif event_type == 'membership.notifications.removed':
                if str(msg['event']['data']['removed_user']['id']) in group.users:
                    group.users[str(msg['event']['data']['removed_user']['id'])].times_kicked += 1

        if msg['sender_id'] not in group.users:
            temp_user = groupme.User(msg['sender_id'])
            temp_user.aliases.append(msg['name'])
            temp_user.avatars.append(msg['avatar_url'])
            temp_user.total_messages += 1
            group.users[msg['sender_id']] = temp_user
        else:
            group.users[msg['sender_id']].total_messages += 1
            group.users[msg['sender_id']].unique_name(msg['name'])
            if msg['avatar_url'] not in group.users[msg['sender_id']].avatars:
                group.users[msg['sender_id']].avatars.append(msg['avatar_url'])

            for like in msg['favorited_by']:
                group.users[msg['sender_id']].likes_received += 1
                if like in group.users:
                    group.users[like].likes_given += 1
                else:
                    group.users[like] = groupme.User(like)
                    group.users[like].likes_given += 1

    group.do_statistics()

    # END TIMER
    for x in group.users:
        print(str(group.users[x]) + "\n")
    print(group.group_names.keys())
    print(group.group_avatars.keys())
    print(group)


    z = 0
    for k in sorted(group.unique_messages.items(), key=lambda x: x[1], reverse=True):
        #if len(k[0].split()) == 6:
        print(str(z) + ": " + str(k))
        z += 1
        if z > 250:
            break
    print(d)


if __name__ == '__main__':
    main()
