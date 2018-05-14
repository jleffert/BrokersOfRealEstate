class House < ApplicationRecord
  paginates_per 25
  belongs_to :lot
  has_many :rooms

  def images
    lot.images
  end

  def address
    lot.address
  end

  def directions
    lot.directions
  end

  def lot_square_footage
    lot.square_footage
  end

  ROOM_NAMES = {
    "MasterBedroom": "RESIMAST",
    "2ndBedroom": "RESI2NDB",
    "3rdBedroom": "RESI3RDB",
    "4thBedroom": "RESI4TBD",
    "FamilyRoom": "RESIFAMR",
    "Kitchen": "RESIKITH",
    "2ndKitchen": "RESI2NDK",
    "LivingRoom": "RESILIVR",
    "FormalDiningRoom": "RESIFODR",
    "InformalDiningRoom": "RESIINDR",
    "LaundryRoom": "RESILAUN",
    "Office": "RESIOFFI",
    "RecreationRoom": "RESIRECR"
  }

  INTERIOR_FEATURES = {
    "CEIL": "Ceiling Fan",
    "PANT": "Pantry",
    "2NDK": "Second Kitchen",
    "FODR": "Formal Dining Room",
    "WHIR": "Whirlpool",
    "WETB": "Wetbar",
    "SKYL": "Skylight",
    "DRAN": "Drain Tile",
    "JACK": "Jack and Jill Bath"
  }

  APPLIANCES = {
    "CEIL": "Ceiling Fan",
    "DRAN": "Draing Tile",
    "DISH": "Dishwasher",
    "DISP": "Disposal",
    "HUMI": "Humidifier",
    "RGOV": "Range/Oven",
    "MICR": "Microwave",
    "REFG": "Refrigerator",
    "SMOK": "Smoke Detector",
    "JACK": "Jack and Jill Bath"
  }

  BASEMENT = {
    "DAYL": "Daylight",
    "WLKO": "Walkout",
    "EGRE": "Egress",
    "NONE": "None"
  }


  COOLING = {
    "CENT": "Central",
    "OTHR": "Other"
  } 

  HEATING = {
    "FORC": "Forced Air",
    "HEAT": "Heat Pump",
    "OTHR": "Other"
  }

  FOUNDATION = {
    "POUR": "Poured",
    "CONC": "Concrete",
    "SLAB": "Slab"
  }

  EXTERIOR = {
    "BRIC": "Brick",
    "VINL": "Vinyl",
    "STON": "Stone",
    "FRAM": "Frame",
    "STUC": "Stucco",
    "CEBS": "Cement Board Siding"
  }

  EXTERIOR_FEATURES = {
    "ENCL": "Enclosed Porch/Deck",
    "EXPK": "Extra Parking Slab",
    "OUTB": "Outbuilding",
    "PATI": "Patio",
    "SPEN": "Seperate Entrance",
    "UNDR": "Underground Sprinklers",
    "COVR": "Covered Porch",
    "DECK": "Deck"
  }

  MISC_FEATURES = {
    "BUYW": "Buyer Warranty",
    "GRDO": "Garage Door Opener",
    "GRFD": "Garage Floor Drain",
    "INTR": "Intercom System",
    "SECR": "Security System",
    "SUMP": "Sump Pump",
    "WARP": "Water Purifier",
    "WATS": "Water Softener"
  }

  FUEL = {
    "ELEC": "Electric",
    "NGAS": "Natural Gas"
  }
end
