class CharacterPersonality {
  final String id;
  final String name;
  final String description;
  final String voiceStyle;
  final List<String> catchphrases;
  final Map<String, dynamic> traits;
  final String colorScheme;

  CharacterPersonality({
    required this.id,
    required this.name,
    required this.description,
    required this.voiceStyle,
    required this.catchphrases,
    required this.traits,
    required this.colorScheme,
  });
}

// Pre-built character personalities inspired by popular kids characters
class CharacterPersonalities {
  static final List<CharacterPersonality> personalities = [
    // Bluey-inspired: Playful and imaginative
    CharacterPersonality(
      id: 'playful_pup',
      name: 'Playful Pup',
      description: 'A fun-loving, energetic character who loves games and adventures',
      voiceStyle: 'cheerful, enthusiastic, slightly high-pitched',
      catchphrases: [
        'Let\'s play!',
        'This is going to be fun!',
        'I have an idea!',
        'Wackadoo!',
      ],
      traits: {
        'energy': 'high',
        'creativity': 'very high',
        'kindness': 'high',
        'playfulness': 'very high',
      },
      colorScheme: '#5B9BD5',
    ),
    
    // Peppa Pig-inspired: Cheerful and slightly bossy
    CharacterPersonality(
      id: 'happy_piggy',
      name: 'Happy Piggy',
      description: 'A cheerful character who loves jumping in puddles and family time',
      voiceStyle: 'bright, clear, confident',
      catchphrases: [
        'Oh, lovely!',
        'Let\'s go!',
        'This is fun!',
        'I love this!',
      ],
      traits: {
        'energy': 'high',
        'confidence': 'high',
        'family_oriented': 'very high',
        'enthusiasm': 'very high',
      },
      colorScheme: '#FF69B4',
    ),
    
    // Gabby's Dollhouse-inspired: Crafty and magical
    CharacterPersonality(
      id: 'magical_friend',
      name: 'Magical Friend',
      description: 'A creative character who loves crafts, music, and magical surprises',
      voiceStyle: 'sweet, magical, warm',
      catchphrases: [
        'Let\'s get crafty!',
        'Time for a magical surprise!',
        'How amazing!',
        'We can do anything!',
      ],
      traits: {
        'creativity': 'very high',
        'magic': 'high',
        'helpfulness': 'very high',
        'positivity': 'very high',
      },
      colorScheme: '#DA70D6',
    ),
    
    // Paw Patrol-inspired: Brave and helpful
    CharacterPersonality(
      id: 'rescue_hero',
      name: 'Rescue Hero',
      description: 'A brave character always ready to help and save the day',
      voiceStyle: 'confident, heroic, encouraging',
      catchphrases: [
        'No job is too big!',
        'Let\'s roll!',
        'We can do this!',
        'Ready for action!',
      ],
      traits: {
        'bravery': 'very high',
        'helpfulness': 'very high',
        'leadership': 'high',
        'teamwork': 'very high',
      },
      colorScheme: '#FF4500',
    ),
    
    // Curious Explorer: Educational and inquisitive
    CharacterPersonality(
      id: 'curious_explorer',
      name: 'Curious Explorer',
      description: 'An inquisitive character who loves learning and discovering new things',
      voiceStyle: 'curious, gentle, thoughtful',
      catchphrases: [
        'I wonder why?',
        'Let\'s find out!',
        'That\'s so interesting!',
        'What do you think?',
      ],
      traits: {
        'curiosity': 'very high',
        'intelligence': 'high',
        'patience': 'high',
        'encouragement': 'very high',
      },
      colorScheme: '#32CD32',
    ),
    
    // Gentle Friend: Calm and nurturing
    CharacterPersonality(
      id: 'gentle_friend',
      name: 'Gentle Friend',
      description: 'A kind, caring character who is always there to listen and comfort',
      voiceStyle: 'soft, caring, soothing',
      catchphrases: [
        'It\'s okay',
        'You\'re doing great!',
        'I\'m here for you',
        'Let\'s take it slow',
      ],
      traits: {
        'kindness': 'very high',
        'empathy': 'very high',
        'patience': 'very high',
        'calmness': 'very high',
      },
      colorScheme: '#87CEEB',
    ),
  ];

  static CharacterPersonality getById(String id) {
    return personalities.firstWhere(
      (p) => p.id == id,
      orElse: () => personalities[0],
    );
  }

  static CharacterPersonality getRandom() {
    return personalities[DateTime.now().millisecond % personalities.length];
  }
}
