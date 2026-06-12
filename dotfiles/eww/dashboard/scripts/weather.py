#!/usr/bin/env python3

import json
import urllib.request
import os
import time
from datetime import datetime, date, timedelta

CACHE_FILE = os.path.expanduser("~/.cache/eww_weather_cache.json")
CACHE_DURATION_SECONDS = 900  # 15 minutes

FALLBACK_DATA = {
    "location": "Inconnu",
    "temp": "0",
    "desc": "Inconnu",
    "type": "day",
    "humidity": "0",
    "wind": "0",
    "icon": "",
    "icon_class": "weather-icon unknown",
    "forecast": [],
    "sunrise": "--:--",
    "sunset": "--:--",
}

DAYS_FR = {
    "Monday": "Lundi",
    "Tuesday": "Mardi",
    "Wednesday": "Mercredi",
    "Thursday": "Jeudi",
    "Friday": "Vendredi",
    "Saturday": "Samedi",
    "Sunday": "Dimanche"
}

MONTHS_FR = {
    "Jan": "janv.",
    "Feb": "févr.",
    "Mar": "mars",
    "Apr": "avr.",
    "May": "mai",
    "Jun": "juin",
    "Jul": "juil.",
    "Aug": "août",
    "Sep": "sept.",
    "Oct": "oct.",
    "Nov": "nov.",
    "Dec": "déc."
}

def get_wmo_weather(code, is_day=True):
    wmo_data = {
        0: ("Ciel dégagé", "", "󰖔", "weather-icon clear-day", "weather-icon clear-night"),
        1: ("Principalement dégagé", "", "", "weather-icon cloud-day", "weather-icon cloud-night"),
        2: ("Partiellement nuageux", "", "", "weather-icon cloud-day", "weather-icon cloud-night"),
        3: ("Couvert", "", "", "weather-icon cloudy", "weather-icon cloudy"),
        45: ("Brouillard", "", "", "weather-icon mist", "weather-icon mist"),
        48: ("Brouillard givrant", "", "", "weather-icon mist", "weather-icon mist"),
        51: ("Bruine légère", "󰖗", "󰖗", "weather-icon drizzle", "weather-icon drizzle"),
        53: ("Bruine modérée", "󰖗", "󰖗", "weather-icon drizzle", "weather-icon drizzle"),
        55: ("Bruine dense", "󰖗", "󰖗", "weather-icon drizzle", "weather-icon drizzle"),
        56: ("Bruine verglaçante légère", "󰖗", "󰖗", "weather-icon drizzle", "weather-icon drizzle"),
        57: ("Bruine verglaçante dense", "󰖗", "󰖗", "weather-icon drizzle", "weather-icon drizzle"),
        61: ("Pluie légère", "", "", "weather-icon rain", "weather-icon rain"),
        63: ("Pluie modérée", "", "", "weather-icon rain", "weather-icon rain"),
        65: ("Pluie forte", "", "", "weather-icon rain", "weather-icon rain"),
        66: ("Pluie verglaçante légère", "󰖒", "󰖒", "weather-icon snow", "weather-icon snow"),
        67: ("Pluie verglaçante forte", "󰖒", "󰖒", "weather-icon snow", "weather-icon snow"),
        71: ("Chute de neige légère", "󰖘", "󰖘", "weather-icon snow", "weather-icon snow"),
        73: ("Chute de neige modérée", "󰖘", "󰖘", "weather-icon snow", "weather-icon snow"),
        75: ("Chute de neige forte", "", "", "weather-icon snow", "weather-icon snow"),
        77: ("Grains de neige", "󰖘", "󰖘", "weather-icon snow", "weather-icon snow"),
        80: ("Averses de pluie légères", "", "", "weather-icon rain", "weather-icon rain"),
        81: ("Averses de pluie modérées", "", "", "weather-icon rain", "weather-icon rain"),
        82: ("Averses de pluie violentes", "", "", "weather-icon rain", "weather-icon rain"),
        85: ("Averses de neige légères", "󰖘", "󰖘", "weather-icon snow", "weather-icon snow"),
        86: ("Averses de neige fortes", "", "", "weather-icon snow", "weather-icon snow"),
        95: ("Orage", "󰖓", "󰖓", "weather-icon thunder", "weather-icon thunder"),
        96: ("Orage avec grêle légère", "󰖓", "󰖓", "weather-icon thunder", "weather-icon thunder"),
        99: ("Orage avec grêle forte", "󰖓", "󰖓", "weather-icon thunder", "weather-icon thunder"),
    }
    
    desc, icon_day, icon_night, class_day, class_night = wmo_data.get(
        code, ("Inconnu", "", "", "weather-icon unknown", "weather-icon unknown")
    )
    
    return {
        "desc": desc,
        "icon": icon_day if is_day else icon_night,
        "class": class_day if is_day else class_night
    }

def load_cache():
    if os.path.exists(CACHE_FILE):
        try:
            with open(CACHE_FILE, "r") as f:
                return json.load(f)
        except Exception:
            return None
    return None

def save_cache(data):
    try:
        os.makedirs(os.path.dirname(CACHE_FILE), exist_ok=True)
        with open(CACHE_FILE, "w") as f:
            json.dump(data, f)
    except Exception:
        pass

def get_location():
    try:
        req = urllib.request.Request("http://ip-api.com/json", headers={"User-Agent": "EwwWeatherWidget/1.0"})
        with urllib.request.urlopen(req, timeout=5) as response:
            data = json.loads(response.read().decode())
            if data.get("status") == "success":
                return {
                    "city": data.get("city", "Paris"),
                    "lat": data.get("lat", 48.8566),
                    "lon": data.get("lon", 2.3522),
                    "timezone": data.get("timezone", "Europe/Paris")
                }
    except Exception:
        pass
    return {
        "city": "Paris",
        "lat": 48.8566,
        "lon": 2.3522,
        "timezone": "Europe/Paris"
    }

def fetch_weather(loc):
    url = (
        f"https://api.open-meteo.com/v1/forecast"
        f"?latitude={loc['lat']}&longitude={loc['lon']}"
        f"&current=temperature_2m,relative_humidity_2m,is_day,weather_code,wind_speed_10m"
        f"&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset"
        f"&timezone={loc['timezone']}"
    )
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "EwwWeatherWidget/1.0"})
        with urllib.request.urlopen(req, timeout=8) as response:
            return json.loads(response.read().decode())
    except Exception:
        return None

def main():
    # Check if cache is fresh
    if os.path.exists(CACHE_FILE):
        mtime = os.path.getmtime(CACHE_FILE)
        if time.time() - mtime < CACHE_DURATION_SECONDS:
            cached = load_cache()
            if cached:
                print(json.dumps(cached))
                return

    # Fetch fresh data
    loc = get_location()
    weather_raw = fetch_weather(loc)

    if not weather_raw:
        # Fallback to cache if request fails
        cached = load_cache()
        if cached:
            print(json.dumps(cached))
        else:
            print(json.dumps(FALLBACK_DATA))
        return

    try:
        current = weather_raw["current"]
        daily = weather_raw["daily"]
        
        is_day = current["is_day"] == 1
        weather_info = get_wmo_weather(current["weather_code"], is_day)
        
        temp_c = str(round(current["temperature_2m"]))
        humidity = str(current["relative_humidity_2m"])
        wind_kmh = str(round(current["wind_speed_10m"]))
        
        # Open-Meteo returns sunrise/sunset in ISO 8601 like "2026-06-12T05:48"
        sunrise = daily["sunrise"][0].split("T")[1] if "T" in daily["sunrise"][0] else "--:--"
        sunset = daily["sunset"][0].split("T")[1] if "T" in daily["sunset"][0] else "--:--"
        
        # Forecast for next 4 days (days 1, 2, 3, 4)
        forecast_list = []
        
        for i in range(1, 5):
            if i >= len(daily["time"]):
                break
            
            # Parse forecast date
            forecast_time_str = daily["time"][i]
            dt = datetime.strptime(forecast_time_str, "%Y-%m-%d")
            
            f_code = daily["weather_code"][i]
            f_weather = get_wmo_weather(f_code, is_day=True)
            
            # Open-Meteo returns float values for temperature
            f_temp = round(daily["temperature_2m_max"][i], 1)
            
            # Translate day name and month to French
            day_en = dt.strftime("%A")
            day_fr = DAYS_FR.get(day_en, day_en)
            
            day_num = dt.strftime("%d")
            month_en = dt.strftime("%b")
            month_fr = MONTHS_FR.get(month_en, month_en)
            date_fr = f"{day_num} {month_fr}"
            
            forecast_list.append({
                "day": day_fr,
                "date": date_fr,
                "temp": f_temp,
                "desc": f_weather["desc"],
                "icon": f_weather["icon"],
                "icon_class": f_weather["class"],
            })

        output = {
            "location": loc["city"],
            "temp": temp_c,
            "desc": weather_info["desc"],
            "type": "day" if is_day else "night",
            "humidity": humidity,
            "wind": wind_kmh,
            "icon": weather_info["icon"],
            "icon_class": weather_info["class"],
            "forecast": forecast_list,
            "sunrise": sunrise,
            "sunset": sunset,
        }

        save_cache(output)
        print(json.dumps(output))

    except Exception:
        # Fallback to cache if parsing fails
        cached = load_cache()
        if cached:
            print(json.dumps(cached))
        else:
            print(json.dumps(FALLBACK_DATA))

if __name__ == "__main__":
    main()
