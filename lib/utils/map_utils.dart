import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  // Default center for Bangalore
  static const LatLng defaultCenter = LatLng(12.9716, 77.5946);

  // Cache for bus marker icons (to avoid recreating them)
  static final Map<String, BitmapDescriptor> _markerIconCache = {};

  // Method to create custom bus marker
  static Future<BitmapDescriptor> getBusMarkerIcon() async {
    if (_markerIconCache.containsKey('bus')) {
      return _markerIconCache['bus']!;
    }

    // Create a custom marker icon using canvas
    final size = 80.0;
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..color = Colors.amber;

    // Draw circle background
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2, paint);

    // Draw bus icon
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: const TextSpan(
        text: '🚌',
        style: TextStyle(fontSize: 40, color: Colors.black),
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size / 2 - textPainter.width / 2,
        size / 2 - textPainter.height / 2,
      ),
    );

    // Convert to image
    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);

    if (data != null) {
      final icon = BitmapDescriptor.bytes(data.buffer.asUint8List());
      _markerIconCache['bus'] = icon;
      return icon;
    }

    // Fallback to default marker
    return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
  }

  // Method to handle camera movement to a specific location
  static Future<void> animateToLocation(
    GoogleMapController controller,
    LatLng target, {
    double zoom = 15.0,
  }) async {
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom),
      ),
    );
  }
}
