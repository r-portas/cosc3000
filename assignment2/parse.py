"""
Parses the input data and does the following operations

- Loads the CSV dataset
- Geocodes city names to latitude and longitude
- Exports the data as JSON
"""

import argparse
import csv
import json
import urllib.parse
import urllib.request
import os
import time
import tableprint

GEOCODE_API_KEY = os.environ.get('GEOCODE_API_KEY')
if GEOCODE_API_KEY == None:
    raise Exception('GEOCODE_API_KEY environment variable not defined')


GEOCODE_URL = 'https://maps.googleapis.com/maps/api/geocode/json?{}'

def read_csv(filename):
    """ Reads a CSV file and returns the data entries """

    data_entries = []

    with open(filename, 'r') as csvfile:
        reader = csv.reader(csvfile)

        # Skip the header
        next(reader)

        for row in reader:
            entry = {
                'city_name': row[0],
                'crime_rate': float(row[4])
            }

            data_entries.append(entry)

    return data_entries

def print_info(json_data):
    components = json_data['results'][0]['address_components'][0]
    location = json_data['results'][0]['geometry']['location']
    types = ', '.join(components['types'])
    data = [
        components['long_name'],
        location['lat'],
        location['lng']
    ]


    print(tableprint.row(data, width=30))

def geocode_city_name(city_name):
    """ Geocodes a city name and returns the address """

    params = {
        'address': city_name,
        'key': GEOCODE_API_KEY
    }


    encoded_params = urllib.parse.urlencode(params)
    url = GEOCODE_URL.format(encoded_params)

    coords = ()

    try:
        with urllib.request.urlopen(url) as f:
            json_data = json.loads(f.read())
            location = json_data['results'][0]['geometry']['location']
            coords = (location['lat'], location['lng'])
            print_info(json_data)

    except urllib.error.HTTPError as err:
        print('Got error code: {}'.format(err.code))

    return coords

def geocode_crime_data(data_entries):
    """ Geocodes a list of crime data entries """

    print(tableprint.header(['City Name', 'Lat', 'Long'], width=30))
    for entry in data_entries:
        coords = geocode_city_name(entry['city_name'])
        entry['coords'] = coords

        # Add a delay for API limiting
        time.sleep(0.1)

    print(tableprint.bottom(3, width=30))

    return data_entries

def save_json_file(data, filename):
    """ Saves the data as a JSON file """
    with open(filename, 'w') as f:
        json_data = json.dumps(data)
        f.write(json_data)
        

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('filename', help='The filename of the data file')
    args = parser.parse_args()

    data_entries = read_csv(args.filename)

    data_entries = geocode_crime_data(data_entries)

    save_json_file(data_entries, 'output.json')

