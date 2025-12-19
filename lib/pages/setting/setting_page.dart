import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Color _bg = Color(0xFFFAF9F6);
const Color _titleColor = Color(0xD9006400);

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _profileOpen = false;
  bool _notificationOpen = false;
  bool _accountOpen = false;
  bool _pushEnabled = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 28, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '設定',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: _titleColor,
                          fontFamily: 'Building',
                          shadows: [
                            Shadow(
                              color: Color.fromRGBO(0, 0, 0, 0.25),
                              offset: Offset(0, 3),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/icons/setting.svg',
                        width: 32,
                        height: 32,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _SectionTile(
                    title: 'プロフィール設定',
                    isOpen: _profileOpen,
                    onTap: () => setState(() => _profileOpen = !_profileOpen),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        const Text(
                          'ユーザー名変更',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontFamily: 'Building',
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  hintText: '名前を入力してください',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF9E9E9E),
                                    fontFamily: 'Banana',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFB0B0B0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _titleColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 3,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('ユーザー名を更新しました'),
                                  ),
                                );
                              },
                              child: const Text(
                                '保存',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontFamily: 'Building',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionTile(
                    title: '通知設定',
                    isOpen: _notificationOpen,
                    onTap: () =>
                        setState(() => _notificationOpen = !_notificationOpen),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Text(
                                'プッシュ通知',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontFamily: 'Building',
                                ),
                              ),
                            ),
                            Switch(
                              value: _pushEnabled,
                              activeColor: Colors.white,
                              activeTrackColor:
                                  const Color.fromARGB(255, 94, 158, 109),
                              onChanged: (v) =>
                                  setState(() => _pushEnabled = v),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionTile(
                    title: 'アカウント',
                    isOpen: _accountOpen,
                    onTap: () => setState(() => _accountOpen = !_accountOpen),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('ログアウトしました')),
                            );
                          },
                          child: const Text(
                            'ログアウト',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontFamily: 'Building',
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('アカウント削除は未実装です')),
                            );
                          },
                          child: const Text(
                            'アカウント削除',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.red,
                              fontFamily: 'Building',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 24,
              left: 12,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: _titleColor),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  const _SectionTile({
    required this.title,
    required this.isOpen,
    required this.onTap,
    required this.child,
  });

  final String title;
  final bool isOpen;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Icon(
                isOpen ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                color: Colors.black,
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'Building',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 140,
          height: 1.2,
          color: Colors.black.withOpacity(0.4),
        ),
        if (isOpen) child,
      ],
    );
  }
}
