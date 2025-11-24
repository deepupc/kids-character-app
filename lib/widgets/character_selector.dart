import 'package:flutter/material.dart';
import '../models/character_personality.dart';

class CharacterSelector extends StatelessWidget {
  final Function(CharacterPersonality) onPersonalitySelected;
  final String? selectedPersonalityId;

  const CharacterSelector({
    Key? key,
    required this.onPersonalitySelected,
    this.selectedPersonalityId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🎭 Choose Your Character\'s Personality!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.purple[700],
            ),
          ),
          SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: CharacterPersonalities.personalities.map((personality) {
                return _buildPersonalityCard(context, personality);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalityCard(
    BuildContext context,
    CharacterPersonality personality,
  ) {
    final isSelected = selectedPersonalityId == personality.id;
    final color = _parseColor(personality.colorScheme);

    return GestureDetector(
      onTap: () => onPersonalitySelected(personality),
      child: Container(
        width: 180,
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Personality icon/emoji
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  _getPersonalityEmoji(personality.id),
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),
            SizedBox(height: 12),
            
            // Name
            Text(
              personality.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 8),
            
            // Description
            Text(
              personality.description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 12),
            
            // Catchphrase
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '"${personality.catchphrases[0]}"',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: color,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
    } catch (e) {
      return Colors.blue;
    }
  }

  String _getPersonalityEmoji(String personalityId) {
    switch (personalityId) {
      case 'playful_pup':
        return '🐕';
      case 'happy_piggy':
        return '🐷';
      case 'magical_friend':
        return '✨';
      case 'rescue_hero':
        return '🦸';
      case 'curious_explorer':
        return '🔍';
      case 'gentle_friend':
        return '🤗';
      default:
        return '😊';
    }
  }
}
