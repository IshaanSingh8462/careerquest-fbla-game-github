*** FBLA Computer Game and Simulation Programming Submission ***

Progress:
- Doctor scene: interact with npc to obtain visible symptoms, then determine prescription based off of symptoms, as well as provide a lifestyle change to prevent condition from occuring
  - doctor button
    - start button to start doctor roleplay
  - patient npc
    - interactable -> talk about name, date of birth, etc. and symptoms
  - doctor clipboard
    - notes info about npc (name, dob, symptoms)
    - prescribe medicine/treatement to npc
  - doctor book
    - guide for player to analyze symptoms and conclude with a prescription + notes on how the npc should behave
    - additional info about the condition (what it is, it's symptoms, and it's effects)
  - points
    - +50 for every info of npc (first name, last name, dob, gender)
    - +50 for correct symptoms
    - +50 for correct prescription
    - timer
      - +50 for <90 sec
      - +30 for <120 sec
      - +10 for <150 sec
      - 0 for >150 sec

To Do:
- Doctor: code doctor tools used to obtain symptom data (ui bar at top of screen - hotbar for tools)
  - stethoscope -> shortness of breath, cough, chest pain
  - thermometer -> fever
  - tongue depressor -> fever, cough, sore throat,
  - glucose meter -> diabetes
  - neurological exam kit -> dizziness, fatigue
  - physical exam -> joint pain, swelling
  - talking -> nausea, vomit, headache, fatigue, frequent urination, thirsty/hungry
  - interact with tool -> gives hints (high glucose, swelling, redness, etc.)
- Doctor: create dialogue for npc -> interactions with tools, asking for personal info, etc.
- Electrician scene: perform task (switch high lightbulbs, fix broken outlets, rewire broken cords, etc.)
  - fusebox: turns off electricity at working location (room)
  - tools: screwdriver, linesman pliers, voltage test, wire cutter, electrical tape
  - complete task
  - test fix
  - points
    - electricuted = -25 health, -25 points
    - timer
      - +100 points if <4 min
      - +75 points if <5:30 min
      - +50 points if <7 min
      - 0 points if >7 min
- Accountant:
- One more Career (TBD)
