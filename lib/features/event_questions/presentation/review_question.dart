import 'package:flutter/material.dart';
import 'package:pos/features/shared/widgets/epic_rpg_background.dart';

enum ReviewQuestionType { rating, text, multiChoice }

class ReviewQuestion {
  final String id;
  final String title;
  final String subtitle;
  final ReviewQuestionType type;
  final int maxRating;
  final List<String> options;

  const ReviewQuestion({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    this.maxRating = 5,
    this.options = const [],
  });
}

class EventReviewScreen extends StatefulWidget {
  const EventReviewScreen({super.key});

  @override
  State<EventReviewScreen> createState() => _EventReviewScreenState();
}

class _EventReviewScreenState extends State<EventReviewScreen> {
  final List<ReviewQuestion> _questions = const [
    ReviewQuestion(
      id: 'overall',
      title: 'How was the hackathon?',
      subtitle: 'Rate your overall experience at this event.',
      type: ReviewQuestionType.rating,
      maxRating: 5,
    ),
    ReviewQuestion(
      id: 'vibes',
      title: 'What did you like the most?',
      subtitle: 'Tell Draggi what made this hackathon special.',
      type: ReviewQuestionType.text,
    ),
    ReviewQuestion(
      id: 'format',
      title: 'Which parts did you enjoy?',
      subtitle: 'You can choose more than one.',
      type: ReviewQuestionType.multiChoice,
      options: [
        'Workshops',
        'Mentorship',
        'Night hacking',
        'Networking',
        'Prizes',
      ],
    ),
  ];

  int _currentIndex = 0;
  final Map<String, dynamic> _answers = {};

  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  ReviewQuestion get _currentQuestion => _questions[_currentIndex];

  bool get _isLastQuestion => _currentIndex == _questions.length - 1;

  bool get _hasAnswerForCurrent {
    final q = _currentQuestion;
    final answer = _answers[q.id];

    switch (q.type) {
      case ReviewQuestionType.rating:
        return (answer is int) && answer > 0;
      case ReviewQuestionType.text:
        return (answer is String) && answer.trim().isNotEmpty;
      case ReviewQuestionType.multiChoice:
        return (answer is Set<int>) && answer.isNotEmpty;
    }
  }

  void _onRatingTap(int value) {
    setState(() {
      _answers[_currentQuestion.id] = value;
    });
  }

  void _onTextChanged(String value) {
    setState(() {
      _answers[_currentQuestion.id] = value;
    });
  }

  void _onMultiChoiceTap(int index) {
    final id = _currentQuestion.id;
    final current = (_answers[id] as Set<int>?) ?? <int>{};

    setState(() {
      if (current.contains(index)) {
        current.remove(index);
      } else {
        current.add(index);
      }
      _answers[id] = current;
    });
  }

  void _goNext() {
    if (!_hasAnswerForCurrent) return;

    if (_isLastQuestion) {
      Navigator.of(context).pop(_answers);
    } else {
      setState(() {
        _currentIndex++;
        final next = _currentQuestion;
        if (next.type == ReviewQuestionType.text) {
          _textController.text = (_answers[next.id] as String?) ?? '';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentIndex + 1) / _questions.length.toDouble();

    return Scaffold(
      body: EpicRpgBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                _ReviewProgressHeader(
                  currentIndex: _currentIndex,
                  total: _questions.length,
                  progress: progress,
                ),
                const SizedBox(height: 24),

                SizedBox(
                  height: 180,
                  child: Image.asset(
                    'assets/images/dragons/dragon_scroll.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: _QuestionContent(
                    question: _currentQuestion,
                    answers: _answers,
                    onRatingTap: _onRatingTap,
                    onTextChanged: _onTextChanged,
                    onMultiChoiceTap: _onMultiChoiceTap,
                    textController: _textController,
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _hasAnswerForCurrent ? _goNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      disabledBackgroundColor: const Color(
                        0xFF6366F1,
                      ).withOpacity(0.4),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: Text(
                      _isLastQuestion ? 'Finish' : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReviewProgressHeader extends StatelessWidget {
  final int currentIndex;
  final int total;
  final double progress;

  const _ReviewProgressHeader({
    required this.currentIndex,
    required this.total,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF818CF8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '${currentIndex + 1} of $total',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _QuestionContent extends StatelessWidget {
  final ReviewQuestion question;
  final Map<String, dynamic> answers;
  final void Function(int rating) onRatingTap;
  final void Function(String text) onTextChanged;
  final void Function(int index) onMultiChoiceTap;
  final TextEditingController textController;

  const _QuestionContent({
    required this.question,
    required this.answers,
    required this.onRatingTap,
    required this.onTextChanged,
    required this.onMultiChoiceTap,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    Widget input;

    switch (question.type) {
      case ReviewQuestionType.rating:
        final current = (answers[question.id] as int?) ?? 0;
        input = _EggRatingRow(
          maxRating: question.maxRating,
          currentRating: current,
          onTap: onRatingTap,
        );
        break;

      case ReviewQuestionType.text:
        input = _TextAnswerField(
          controller: textController,
          onChanged: onTextChanged,
        );
        break;

      case ReviewQuestionType.multiChoice:
        final selected = (answers[question.id] as Set<int>?) ?? <int>{};
        input = _MultiChoiceChips(
          options: question.options,
          selected: selected,
          onTap: onMultiChoiceTap,
        );
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Text(
          question.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          question.subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 24),
        input,
      ],
    );
  }
}

class _EggRatingRow extends StatelessWidget {
  final int maxRating;
  final int currentRating;
  final void Function(int rating) onTap;

  const _EggRatingRow({
    required this.maxRating,
    required this.currentRating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxRating, (index) {
        final value = index + 1;
        final isSelected = value <= currentRating;

        return GestureDetector(
          onTap: () => onTap(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.all(4),
            child: Icon(
              Icons.egg,
              size: isSelected ? 40 : 34,
              color: isSelected
                  ? const Color(0xFFFACC15)
                  : Colors.white.withOpacity(0.2),
            ),
          ),
        );
      }),
    );
  }
}

class _TextAnswerField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String text) onChanged;

  const _TextAnswerField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 4,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Write your answer here…',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        filled: true,
        fillColor: Colors.black.withOpacity(0.35),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF818CF8)),
        ),
        contentPadding: const EdgeInsets.all(14),
      ),
    );
  }
}

class _MultiChoiceChips extends StatelessWidget {
  final List<String> options;
  final Set<int> selected;
  final void Function(int index) onTap;

  const _MultiChoiceChips({
    required this.options,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(options.length, (index) {
        final isSelected = selected.contains(index);

        return GestureDetector(
          onTap: () => onTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    )
                  : null,
              color: isSelected ? null : Colors.black.withOpacity(0.35),
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : Colors.white.withOpacity(0.25),
              ),
            ),
            child: Text(
              options[index],
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.9),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
  }
}
