import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heads_up/background_image.dart';
import 'package:heads_up/helper/app_colors.dart';
import 'package:heads_up/helper/dimensions.dart';
import 'package:heads_up/models/category_model.dart';
import 'package:heads_up/pages/game%20pages/chameleon_role_page.dart';
import 'package:heads_up/repos/settings_repo.dart';
import 'package:heads_up/widgets/icon_button.dart';

class ChameleonSetupPage extends StatefulWidget {
  const ChameleonSetupPage({super.key});

  @override
  State<ChameleonSetupPage> createState() => _ChameleonSetupPageState();
}

class _ChameleonSetupPageState extends State<ChameleonSetupPage> {
  static const int _minPlayers = 2;
  static const int _maxPlayers = 15;

  late CategoryModel category;
  late bool canReplay;
  int _impostersCount = 1;
  final List<TextEditingController> _playerControllers = [];
  final List<FocusNode> _playerFocusNodes = [];
  final List<GlobalKey> _playerFieldKeys = [];
  final ScrollController _scrollController = ScrollController();
  bool _hasLoadedPlayers = false;

  @override
  void initState() {
    super.initState();
    category = Get.arguments[0];
    canReplay = Get.arguments[1];
    _loadCachedPlayers();
  }

  Future<void> _loadCachedPlayers() async {
    final cachedNames =
        await Get.find<SettingsRepo>().chameleonPlayerNamesRead();
    if (!mounted) return;

    final playerNames = cachedNames.isEmpty
        ? List<String>.filled(4, '')
        : cachedNames.take(_maxPlayers).toList();
    while (playerNames.length < _minPlayers) {
      playerNames.add('');
    }

    setState(() {
      for (final name in playerNames) {
        _addPlayerController(name);
      }
      _syncImpostersToPlayers();
      _hasLoadedPlayers = true;
    });
  }

  void _updateImposters(int change) {
    setState(() {
      _impostersCount += change;
      if (_impostersCount < 1) _impostersCount = 1;
      if (_impostersCount > _maxImposters) {
        _impostersCount = _maxImposters;
      }
    });
  }

  void _addPlayer({bool requestFocus = true}) {
    if (_playerControllers.length >= _maxPlayers) return;

    setState(() {
      final previousPlayersCount = _playersCount;
      _addPlayerController('');
      _adjustImpostersForPlayerChange(previousPlayersCount);
    });

    if (!requestFocus) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _playerFocusNodes.last.requestFocus();
      _ensurePlayerFieldVisible(_playerControllers.length - 1);
    });
  }

  void _removePlayer(int index) {
    if (_playerControllers.length <= _minPlayers) return;

    setState(() {
      final previousPlayersCount = _playersCount;
      final controller = _playerControllers.removeAt(index);
      final focusNode = _playerFocusNodes.removeAt(index);
      _playerFieldKeys.removeAt(index);
      controller.dispose();
      focusNode.dispose();
      _adjustImpostersForPlayerChange(previousPlayersCount);
    });
  }

  void _addPlayerController(String name) {
    final focusNode = FocusNode();
    focusNode.addListener(() {
      if (!focusNode.hasFocus) return;

      final index = _playerFocusNodes.indexOf(focusNode);
      if (index == -1) return;

      _ensurePlayerFieldVisible(index);
    });

    _playerControllers.add(TextEditingController(text: name));
    _playerFocusNodes.add(focusNode);
    _playerFieldKeys.add(GlobalKey());
  }

  int get _playersCount => _playerControllers.length;

  int get _maxImposters => (_playersCount - 1).clamp(1, _maxPlayers - 1);

  int get _recommendedImposters {
    return _recommendedImpostersFor(_playersCount);
  }

  int _recommendedImpostersFor(int playersCount) {
    final recommended = playersCount ~/ 3;
    final maxImposters = (playersCount - 1).clamp(1, _maxPlayers - 1);
    if (recommended < 1) return 1;
    if (recommended > maxImposters) return maxImposters;
    return recommended;
  }

  void _syncImpostersToPlayers() {
    _impostersCount = _recommendedImposters;
    _clampImposters();
  }

  void _adjustImpostersForPlayerChange(int previousPlayersCount) {
    final previousRecommended = _recommendedImpostersFor(previousPlayersCount);
    final newRecommended = _recommendedImposters;
    _impostersCount += newRecommended - previousRecommended;
    _clampImposters();
  }

  void _clampImposters() {
    if (_impostersCount < 1) _impostersCount = 1;
    if (_impostersCount > _maxImposters) {
      _impostersCount = _maxImposters;
    }
  }

  List<String> get _cachedPlayerNames =>
      _playerControllers.map((controller) => controller.text.trim()).toList();

  List<String> get _gamePlayerNames {
    return _cachedPlayerNames.asMap().entries.map((entry) {
      if (entry.value.isNotEmpty) return entry.value;
      return '${'Player'.tr} ${entry.key + 1}';
    }).toList();
  }

  Future<void> _savePlayerNames() async {
    await Get.find<SettingsRepo>().chameleonPlayerNamesSave(
      _cachedPlayerNames,
    );
  }

  Future<void> _startGame() async {
    await _savePlayerNames();
    Get.to(() => const ChameleonRolePage(), arguments: [
      category,
      _gamePlayerNames,
      _impostersCount,
      canReplay,
    ]);
  }

  Future<void> _closeSetup() async {
    await _savePlayerNames();
    Get.back();
  }

  void _focusNextPlayerField(int index) {
    final nextIndex = index + 1;
    if (nextIndex < _playerFocusNodes.length) {
      _playerFocusNodes[nextIndex].requestFocus();
      _ensurePlayerFieldVisible(nextIndex);
      return;
    }

    _playerFocusNodes[index].unfocus();
  }

  void _ensurePlayerFieldVisible(int index) {
    for (final delay in const [
      Duration(milliseconds: 80),
      Duration(milliseconds: 260),
      Duration(milliseconds: 460),
    ]) {
      Future<void>.delayed(delay, () => _scrollPlayerFieldIntoView(index));
    }
  }

  void _scrollPlayerFieldIntoView(int index) {
    if (!mounted ||
        index >= _playerFieldKeys.length ||
        !_scrollController.hasClients) {
      return;
    }

    final fieldContext = _playerFieldKeys[index].currentContext;
    if (fieldContext == null || !fieldContext.mounted) return;

    final renderObject = fieldContext.findRenderObject();
    if (renderObject is! RenderBox) return;

    final mediaQuery = MediaQuery.of(fieldContext);
    final fieldOffset = renderObject.localToGlobal(Offset.zero);
    final fieldTop = fieldOffset.dy;
    final fieldBottom = fieldTop + renderObject.size.height;
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final hiddenButtonHeight =
        Dimensions.height20 * 2 + Dimensions.font26 + Dimensions.height20;
    final visibleTop = mediaQuery.padding.top + Dimensions.height20;
    final visibleBottom = mediaQuery.size.height -
        keyboardHeight -
        Dimensions.height15 -
        (keyboardHeight == 0 ? hiddenButtonHeight : 0);

    double scrollDelta = 0;
    if (fieldBottom > visibleBottom) {
      scrollDelta = fieldBottom - visibleBottom;
    } else if (fieldTop < visibleTop) {
      scrollDelta = fieldTop - visibleTop;
    }

    if (scrollDelta == 0) return;

    final targetOffset = (_scrollController.offset + scrollDelta).clamp(
      _scrollController.position.minScrollExtent,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    for (final controller in _playerControllers) {
      controller.dispose();
    }
    for (final focusNode in _playerFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundImage(
        child: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final bottomInset = MediaQuery.of(context).viewInsets.bottom;
                  final startButtonHeight = Dimensions.height20 * 2 +
                      Dimensions.font26 +
                      Dimensions.height20;

                  return SingleChildScrollView(
                    controller: _scrollController,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(
                      Dimensions.width20,
                      Dimensions.height45,
                      Dimensions.width20,
                      Dimensions.height20 + bottomInset + startButtonHeight,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight -
                            Dimensions.height45 -
                            Dimensions.height20,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Chameleon setup'.tr,
                            style: TextStyle(
                              fontSize: Dimensions.font26 * 1.2,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              shadows: const [
                                Shadow(blurRadius: 10, color: Colors.black54),
                              ],
                            ),
                          ),
                          SizedBox(height: Dimensions.height20),
                          _buildImposterStepper(
                            count: _impostersCount,
                            onMinus: () => _updateImposters(-1),
                            onPlus: () => _updateImposters(1),
                            canMinus: _impostersCount > 1,
                            canPlus: _impostersCount < _maxImposters,
                          ),
                          SizedBox(height: Dimensions.height20),
                          if (!_hasLoadedPlayers)
                            SizedBox(
                              height: Dimensions.height45 * 4,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          else ...[
                            for (int i = 0; i < _playerControllers.length; i++)
                              _buildPlayerField(i),
                            if (_playerControllers.length < _maxPlayers)
                              _buildAddPlayerTile(),
                          ],
                          SizedBox(height: Dimensions.height30),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                left: Dimensions.width20,
                right: Dimensions.width20,
                bottom: Dimensions.height20,
                child: _buildStartButton(),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: IconBtn(
                  onTap: _closeSetup,
                  icon: Icons.close,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    return GestureDetector(
      onTap: _hasLoadedPlayers ? _startGame : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width45,
              vertical: Dimensions.height20,
            ),
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.glassBorder, width: 1.2),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 8, spreadRadius: 1),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: Dimensions.iconSize24,
                ),
                SizedBox(width: Dimensions.width10),
                Text(
                  'Start game'.tr,
                  style: TextStyle(
                    fontSize: Dimensions.font26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImposterStepper({
    required int count,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
    required bool canMinus,
    required bool canPlus,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimensions.radius20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height15,
          ),
          decoration: BoxDecoration(
            color: AppColors.glassWhite,
            borderRadius: BorderRadius.circular(Dimensions.radius20),
            border: Border.all(color: AppColors.glassBorder, width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Imposters'.tr,
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${'Players'.tr}: $_playersCount',
                    style: TextStyle(
                      fontSize: Dimensions.font16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildRoundIconButton(
                    icon: Icons.remove,
                    isEnabled: canMinus,
                    onTap: onMinus,
                  ),
                  SizedBox(
                    width: Dimensions.width45,
                    child: Text(
                      count.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Dimensions.font26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  _buildRoundIconButton(
                    icon: Icons.add,
                    isEnabled: canPlus,
                    onTap: onPlus,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerField(int index) {
    return Padding(
      key: _playerFieldKeys[index],
      padding: EdgeInsets.only(bottom: Dimensions.height10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width15,
              vertical: Dimensions.height10,
            ),
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: BorderRadius.circular(Dimensions.radius20),
              border: Border.all(color: AppColors.glassBorder, width: 1.2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _playerControllers[index],
                    focusNode: _playerFocusNodes[index],
                    textInputAction: index == _playerControllers.length - 1
                        ? TextInputAction.done
                        : TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    onTap: () => _ensurePlayerFieldVisible(index),
                    onSubmitted: (_) => _focusNextPlayerField(index),
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '${'Player'.tr} ${index + 1}',
                      hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                ),
                _buildRoundIconButton(
                  icon: Icons.remove,
                  isEnabled: _playerControllers.length > _minPlayers,
                  onTap: () => _removePlayer(index),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddPlayerTile() {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.height10),
      child: GestureDetector(
        onTap: _addPlayer,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radius20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              height: Dimensions.height45 * 1.4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                border: Border.all(color: AppColors.glassBorder, width: 1.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: Dimensions.iconSize24,
                  ),
                  SizedBox(width: Dimensions.width10),
                  Text(
                    '${'Player'.tr} ${_playerControllers.length + 1}',
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoundIconButton({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        padding: EdgeInsets.all(Dimensions.height10),
        decoration: BoxDecoration(
          color: isEnabled
              ? Colors.black.withValues(alpha: 0.3)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isEnabled ? Colors.white : Colors.white24,
          size: Dimensions.iconSize24,
        ),
      ),
    );
  }
}
