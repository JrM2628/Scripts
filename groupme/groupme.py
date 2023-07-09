"""

"""


class Group:
    def do_statistics(self):
        most_messages = 0
        for user in self.users.keys():
            if self.users[user].total_messages > most_messages:
                most_messages = self.users[user].total_messages

        print(most_messages)

    def __init__(self, gid, data):
        self.gid = gid
        self.data = data
        self.users = dict()
        self.unique_messages = dict()
        self.group_names = dict()
        self.group_avatars = dict()
        self.total_messages = len(data)
        self.total_polls = 0
        self.total_messages_zero_likes = 0

    def __hash__(self):
        return self.gid

    def __str__(self):
        return "Group: {}" \
               "\n\tUsers: {}" \
               "\n\tTotal messages: {}" \
               "\n\t".format(self.gid, len(self.users), self.total_messages)


class User:
    def unique_name(self, name):
        if name not in self.aliases:
            self.aliases.append(name)
            return True
        return False

    def __init__(self, sender_id):
        self.sender_id = sender_id
        self.aliases = []
        self.avatars = []
        self.likes_given = 0
        self.likes_received = 0
        self.total_messages = 0
        self.times_kicked = 0
        self.times_left = 0
        self.times_mentioned = 0
        self.time_added = 0

    def __hash__(self):
        return self.sender_id

    def __str__(self):
        return "{}" \
               "\n\tAliases: {}" \
               "\n\tAvatars: {}" \
               "\n\tLikes Given: {}" \
               "\n\tLikes Received: {}" \
               "\n\tTotal Messages: {}" \
               "\n\tTimes kicked: {}" \
               "\n\tTimes left: {}".format(self.sender_id, self.aliases, self.avatars, self.likes_given, self.likes_received,
                                           self.total_messages, self.times_kicked, self.times_left)
