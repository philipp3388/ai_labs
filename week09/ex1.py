import psycopg2
from geopy import Nominatim
from faker import Faker

myFaker = Faker()

connection = psycopg2.connect(database = "dvdrental", user = "postgres", password = "postgres", host = "localhost", port = "5432")

# retrieving required addresses
id_from = 400
id_to = 600
substr = '11'

geolocator = Nominatim(user_agent = "USER")

curSession = connection.cursor()
curSession.execute(f'SELECT * FROM addr_lookup(\'{substr}\', {id_from}, {id_to});')
result = curSession.fetchall()

# generating coordinates
for row in result:
    try:
        location = geolocator.geocode(row[1], timeout = None)
        latitude = location.latitude
        longitude = location.longitude
    except Exception:
        print(f"invalid address at row {row.index}")
        latitude = 0
        longitude = 0

    curSession.execute(f'UPDATE ADDRESS SET latitude = {latitude}, longitude = {longitude} WHERE address_id = {row[0]};')

connection.commit()