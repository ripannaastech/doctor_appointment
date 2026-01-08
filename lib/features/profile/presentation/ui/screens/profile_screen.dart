import 'package:doctor_appointment/app/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kPrimaryBlue = Color(0xFF2F80ED);
const kBackground = Color(0xFFF8F9FA);
const kTextDark = Color(0xFF2D3748);
const kTextGray = Color(0xFF718096);
const kCardRadius = 16.0;
const kPadding = 20.0;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String name = '/profileScreen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: Column(
        children: [
          _Header(isEditing: isEditing, onToggle: _toggleEdit),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(kPadding),
              child: Column(
                children: [
                  _PersonalInfoCard(
                    isEditing: isEditing,
                    onToggleEdit: _toggleEdit,
                  ),
                  const SizedBox(height: 20),
                  _LanguageCard(),
                  const SizedBox(height: 20),
                  _LogoutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleEdit() {
    setState(() => isEditing = !isEditing);
  }
}

class _Header extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onToggle;

  const _Header({required this.isEditing, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only( bottom: 32),
      decoration:  BoxDecoration(
        color: AppColors.themeColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),

          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                onPressed: () {},
              ),
              const Expanded(
                child: Text(
                  "Profile",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
           SizedBox(height: 16.h),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.person_outline, color: kPrimaryBlue, size: 40),
          ),
          const SizedBox(height: 16),
          const Text(
            "Ahmed Hassan Mohamed",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "ahmed.hassan@example.com",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonalInfoCard extends StatefulWidget {
  final bool isEditing;
  final VoidCallback onToggleEdit;

  const _PersonalInfoCard({
    required this.isEditing,
    required this.onToggleEdit,
  });

  @override
  State<_PersonalInfoCard> createState() => _PersonalInfoCardState();
}

class _PersonalInfoCardState extends State<_PersonalInfoCard> {
  final _fullNameController = TextEditingController(text: "Ahmed Hassan Mohamed");
  final _emailController = TextEditingController(text: "ahmed.hassan@example.com");
  final _phoneController = TextEditingController(text: "+252 61 234 5678");
  final _dobController = TextEditingController(text: "15-May-1990");
  String _selectedGender = "Male";
  final _addressController = TextEditingController(text: "Mogadishu, Somalia");

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Personal Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kTextDark,
                  ),
                ),
                if (!widget.isEditing)
                  GestureDetector(
                    onTap: widget.onToggleEdit,
                    child: Row(
                      children: [
                        Icon(
                          widget.isEditing ? Icons.close : Icons.edit_outlined,
                          color: kPrimaryBlue,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.isEditing ? "Cancel" : "Edit",
                          style: const TextStyle(
                            color: kPrimaryBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.isEditing)
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: const [
                        Icon(Icons.edit_outlined, color: kPrimaryBlue, size: 18),
                        SizedBox(width: 6),
                        Text(
                          "Cancel",
                          style: TextStyle(
                            color: kPrimaryBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            _buildField(
              Icons.person_outline,
              "Full Name",
              _fullNameController,
              widget.isEditing,
            ),
            _buildField(
              Icons.email_outlined,
              "Email Address",
              _emailController,
              widget.isEditing,
            ),
            _buildField(
              Icons.phone_outlined,
              "Phone Number",
              _phoneController,
              widget.isEditing,
            ),
            _buildDateField(
              Icons.cake_outlined,
              "Date of Birth",
              _dobController,
              widget.isEditing,
            ),
            _buildGenderField(
              Icons.person_outline,
              "Gender",
              widget.isEditing,
            ),
            _buildField(
              Icons.location_on_outlined,
              "Address",
              _addressController,
              widget.isEditing,
              isLast: true,
            ),
            if (widget.isEditing) ...[
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    widget.onToggleEdit();

                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildField(
      IconData icon,
      String label,
      TextEditingController controller,
      bool editable, {
        bool isLast = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + Label row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: kTextGray, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: kTextGray,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Text / TextFormField
          editable
              ? TextFormField(
            controller: controller,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: kTextDark,
            ))

              : Text(
            controller.text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: kTextDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
      IconData icon,
      String label,
      TextEditingController controller,
      bool editable, {
        bool isLast = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + Label
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: kTextGray, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: kTextGray,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Date field / Text
          editable
              ? TextFormField(
            controller: controller,
            readOnly: true,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: kTextDark,
            ),
            onTap: () {
              // Date picker logic
            },
          )
              : Text(
            controller.text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: kTextDark,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildGenderField(
      IconData icon,
      String label,
      bool editable, {
        bool isLast = false,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + Label
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: kTextGray, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: kTextGray,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Dropdown / Text
          editable
              ? DropdownButtonFormField<String>(
            value: _selectedGender,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: kTextDark,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: kPrimaryBlue,
                  width: 2,
                ),
              ),
            ),
            items: const ['Male', 'Female', 'Other']
                .map(
                  (gender) => DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              ),
            )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedGender = value);
              }
            },
          )
              : Text(
            _selectedGender,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: kTextDark,
            ),
          ),
        ],
      ),
    );
  }

}

class _LanguageCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.language, color: kTextDark, size: 20),
                SizedBox(width: 8),
                Text(
                  "Language",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kTextDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _LanguageOption("English", selected: true),
            const SizedBox(height: 12),
            _LanguageOption("Soomaali"),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String text;
  final bool selected;

  const _LanguageOption(this.text, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: selected ? kPrimaryBlue.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? kPrimaryBlue : Colors.grey.shade300,
          width: selected ? 2 : 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? kPrimaryBlue : kTextDark,
            ),
          ),
          if (selected)
            const Icon(Icons.check, color: kPrimaryBlue, size: 20),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.red.shade600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {},
        icon: const Icon(Icons.logout, size: 20),
        label: const Text(
          "Logout",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}