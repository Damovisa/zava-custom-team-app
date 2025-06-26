// Data types for our customizer
export type ProductType = "t-shirt" | "hoodie" | "cap" | "jacket";

export type ColorOption = {
  name: string;
  value: string;
};

export type Team = {
  id: string;
  name: string;
  primaryColor?: string;
};

export type League = {
  id: string;
  name: string;
  teams: Team[];
};

export type Sport = {
  id: string;
  name: string;
  leagues: League[];
};

// Available product colors
export const colorOptions: ColorOption[] = [
  { name: "Black", value: "#000000" },
  { name: "White", value: "#FFFFFF" },
  { name: "Navy", value: "#0A2342" },
  { name: "Red", value: "#D80032" },
  { name: "Royal Blue", value: "#0047AB" },
  { name: "Forest Green", value: "#228B22" },
  { name: "Gray", value: "#808080" },
  { name: "Gold", value: "#FFD700" },
  { name: "Purple", value: "#6A0DAD" },
  { name: "Orange", value: "#FF7F00" },
];

// Available sports, leagues and teams data
export const sportsData: Sport[] = [
  {
    id: "basketball",
    name: "Basketball",
    leagues: [
      {
        id: "nba",
        name: "NBA",
        teams: [
          { id: "lakers", name: "Los Angeles Lakers", primaryColor: "#552583" },
          { id: "celtics", name: "Boston Celtics", primaryColor: "#007A33" },
          { id: "warriors", name: "Golden State Warriors", primaryColor: "#1D428A" },
          { id: "bulls", name: "Chicago Bulls", primaryColor: "#CE1141" },
          { id: "nets", name: "Brooklyn Nets", primaryColor: "#000000" }
        ]
      },
      {
        id: "wnba",
        name: "WNBA",
        teams: [
          { id: "liberty", name: "New York Liberty", primaryColor: "#6ECEB2" },
          { id: "sparks", name: "Los Angeles Sparks", primaryColor: "#FFC72C" },
          { id: "storm", name: "Seattle Storm", primaryColor: "#2C5234" }
        ]
      },
      {
        id: "euroleague",
        name: "EuroLeague",
        teams: [
          { id: "madrid", name: "Real Madrid", primaryColor: "#FFFFFF" },
          { id: "barcelona", name: "FC Barcelona", primaryColor: "#004D98" },
          { id: "cska", name: "CSKA Moscow", primaryColor: "#D52B1E" }
        ]
      }
    ]
  },
  {
    id: "soccer",
    name: "Soccer",
    leagues: [
      {
        id: "premier",
        name: "Premier League",
        teams: [
          { id: "manchester-united", name: "Manchester United", primaryColor: "#DA291C" },
          { id: "liverpool", name: "Liverpool FC", primaryColor: "#C8102E" },
          { id: "arsenal", name: "Arsenal", primaryColor: "#EF0107" },
          { id: "chelsea", name: "Chelsea", primaryColor: "#034694" },
          { id: "manchester-city", name: "Manchester City", primaryColor: "#6CABDD" }
        ]
      },
      {
        id: "la-liga",
        name: "La Liga",
        teams: [
          { id: "real-madrid", name: "Real Madrid", primaryColor: "#FFFFFF" },
          { id: "barcelona", name: "FC Barcelona", primaryColor: "#004D98" },
          { id: "atletico", name: "Atletico Madrid", primaryColor: "#CB3524" }
        ]
      },
      {
        id: "mls",
        name: "MLS",
        teams: [
          { id: "lafc", name: "Los Angeles FC", primaryColor: "#000000" },
          { id: "galaxy", name: "LA Galaxy", primaryColor: "#00245D" },
          { id: "inter-miami", name: "Inter Miami CF", primaryColor: "#F7B5CD" }
        ]
      }
    ]
  },
  {
    id: "football",
    name: "Football",
    leagues: [
      {
        id: "nfl",
        name: "NFL",
        teams: [
          { id: "chiefs", name: "Kansas City Chiefs", primaryColor: "#E31837" },
          { id: "cowboys", name: "Dallas Cowboys", primaryColor: "#003594" },
          { id: "packers", name: "Green Bay Packers", primaryColor: "#203731" },
          { id: "patriots", name: "New England Patriots", primaryColor: "#002244" },
          { id: "49ers", name: "San Francisco 49ers", primaryColor: "#AA0000" }
        ]
      },
      {
        id: "ncaa",
        name: "NCAA",
        teams: [
          { id: "alabama", name: "Alabama Crimson Tide", primaryColor: "#9E1B32" },
          { id: "ohio-state", name: "Ohio State Buckeyes", primaryColor: "#BB0000" },
          { id: "michigan", name: "Michigan Wolverines", primaryColor: "#00274C" }
        ]
      }
    ]
  },
  {
    id: "baseball",
    name: "Baseball",
    leagues: [
      {
        id: "mlb",
        name: "MLB",
        teams: [
          { id: "yankees", name: "New York Yankees", primaryColor: "#0C2340" },
          { id: "dodgers", name: "Los Angeles Dodgers", primaryColor: "#005A9C" },
          { id: "red-sox", name: "Boston Red Sox", primaryColor: "#BD3039" },
          { id: "cubs", name: "Chicago Cubs", primaryColor: "#0E3386" },
          { id: "giants", name: "San Francisco Giants", primaryColor: "#FD5A1E" }
        ]
      }
    ]
  }
];