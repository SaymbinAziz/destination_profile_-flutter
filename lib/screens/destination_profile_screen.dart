

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../models/destination_model.dart';
import '../widgets/destination_widgets.dart';

class DestinationProfileScreen extends StatelessWidget {
  /// The destination data to display.
  final DestinationModel destination;

  const DestinationProfileScreen({
    super.key,
    this.destination = lagoDiBraies,
  });

  @override
  Widget build(BuildContext context) {
    // Force light status-bar icons (white on dark hero)
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      backgroundColor: AppColors.background,
      // ── We use a custom body layout instead of an AppBar so the
      //    hero image can bleed under the status bar edge-to-edge.
      body: _DestinationBody(destination: destination),
    );
  }
}

//  Main scrollable body
class _DestinationBody extends StatelessWidget {
  final DestinationModel destination;
  const _DestinationBody({required this.destination});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          _HeroBlock(destination: destination),

          
          _ContentSection(destination: destination),
        ],
      ),
    );
  }
}


class _HeroBlock extends StatelessWidget {
  final DestinationModel destination;
  const _HeroBlock({required this.destination});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SizedBox(
      
      height: MediaQuery.of(context).size.height * 0.42,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          
          _HeroImage(imageUrl: destination.imageUrl),

          
          const _HeroGradientOverlay(),

          
          Positioned(
            top: topPadding + AppSpacing.sm,
            left: 0,
            right: 0,
            child: _TopBar(),
          ),

          
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.lg,
            child: Text(destination.name, style: AppTextStyles.destinationTitle),
          ),

          
          Positioned(
            top: topPadding + AppSpacing.sm + 8,
            right: AppSpacing.md,
            child: FavouriteButton(initialState: destination.isFavourite),
          ),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  final String imageUrl;
  const _HeroImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
    
      frameBuilder: (context, child, frame, wasSync) {
        if (wasSync) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          child: child,
        );
      },
      // Graceful error state
      errorBuilder: (_, __, ___) => Container(
        color: AppColors.surface,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.image_not_supported_outlined,
                  color: AppColors.textHint, size: 48),
              SizedBox(height: AppSpacing.sm),
              Text('Image unavailable',
                  style: TextStyle(color: AppColors.textHint, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}


class _HeroGradientOverlay extends StatelessWidget {
  const _HeroGradientOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.45, 1.0],
            colors: [
              AppColors.heroOverlayStart,
              AppColors.heroOverlayEnd,
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Row(
        children: [
          // Back button
          _CircleIconButton(
            icon: Icons.chevron_left_rounded,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          // Title (centered by Expanded on both sides)
          Expanded(
            child: Center(
              child: Text('Destination Profile',
                  style: AppTextStyles.appBarTitle),
            ),
          ),
          // Share button
          _CircleIconButton(
            icon: Icons.ios_share_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}


class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.25),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}



class _ContentSection extends StatelessWidget {
  final DestinationModel destination;
  const _ContentSection({required this.destination});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Slight top padding to overlap the gradient seamlessly
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Stats row ──
          _StatsRow(destination: destination),

          const SizedBox(height: AppSpacing.xl),

          // ── Overview section ──
          const SectionHeading(title: 'Overview'),
          const SizedBox(height: AppSpacing.md),
          Text(destination.overviewText, style: AppTextStyles.body),

          const SizedBox(height: AppSpacing.md),

          // ── Location chip ──
          LocationRow(location: destination.location),

          const SizedBox(height: AppSpacing.xl + AppSpacing.sm),

          // ── Book Now CTA ──
          PrimaryButton(
            label: 'Book Now',
            onTap: () {},
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Terms link ──
          Center(
            child: GestureDetector(
              onTap: () {},
              child: const Text(
                'View Terms and Conditions',
                style: AppTextStyles.termsLink,
              ),
            ),
          ),

          // Extra bottom padding for devices with home bar
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + AppSpacing.md,
          ),
        ],
      ),
    );
  }
}


class _StatsRow extends StatelessWidget {
  final DestinationModel destination;
  const _StatsRow({required this.destination});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StatPill(
          icon: Icons.location_on_outlined,
          value: destination.distanceKm,
        ),
        const SizedBox(width: AppSpacing.sm),
        StatPill(
          icon: Icons.access_time_rounded,
          value: destination.durationHrs,
        ),
        const SizedBox(width: AppSpacing.sm),
        StatPill(
          icon: Icons.account_balance_wallet_outlined,
          value: destination.priceUsd,
        ),
      ],
    );
  }
}
