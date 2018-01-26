#!/usr/bin/env python
from peewee import *

DATABASE = 'lullabot'
USER     = 'sandbox'
PASSWD   = 'sandbox'

mysql_db = MySQLDatabase(DATABASE, user=USER, passwd=PASSWD)

class MySQLModel(Model):
    """A base model that will use our MySQL database"""
    class Meta:
	      database = mysql_db

class client_services(MySQLModel):
    """The client services table"""
    first = CharField()
    nick = CharField()
    last = CharField()
    weight = IntegerField()
    ooo = IntegerField()

mysql_db.connect()

# A list of those out of office.
ooo = []

for person in client_services.select().order_by(client_services.weight, fn.Rand()):
    # Use their nickname if available.
    if person.nick:
        name = person.nick
    else:
        name = person.first

    if person.ooo:
        ooo.append(name)
        # Skip this person if they are OOO.
        continue

    # If we have a last person, print a row.
    if 'last_person' in locals():
        print last_person + ' and then ' + name

    # Now specify the last person as this person for the next iteration.
    last_person = name

print "OOO this week: " + ", ".join(ooo)