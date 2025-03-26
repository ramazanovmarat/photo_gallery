import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery/features/ui/bloc/photo_bloc.dart';
import 'package:photo_gallery/features/ui/bloc/photo_event.dart';
import 'package:photo_gallery/features/ui/bloc/photo_state.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {

  @override
  void initState() {
    super.initState();
    _checkInternetAndFetchPhotos();
  }

  Future<void> _checkInternetAndFetchPhotos() async {
    bool hasInternet = await _hasInternetConnection();
    if (!hasInternet) {
      context.read<PhotoBloc>().add(GetSavedPhotos());
      _showOfflineNotification();
    }
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void _showOfflineNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Вы в оффлайн-режиме'),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
      ),
      body: BlocBuilder<PhotoBloc, PhotoState>(
        builder: (context, state) {
          if (state is PhotoLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PhotoLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: state.photos.length,
                itemBuilder: (context, index) {
                  final photo = state.photos[index];
                  return GridTile(
                    footer: Container(
                      padding: const EdgeInsets.all(4.0),
                      color: Colors.black54,
                      child: Text(
                        photo.title,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        photo.url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/error_404.jpg');
                        },
                      ),
                    ),
                  );
                },
              ),
            );

          } else if (state is PhotoError) {
            return Center(child: Text(state.failure.message));
          }
          return Center(child: Text('Ничего не найдено'));
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20.0,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<PhotoBloc>().add(FetchPhotos());
            },
            child: Text('fetch', textAlign: TextAlign.center),
          ),
          FloatingActionButton(
            onPressed: () {
              context.read<PhotoBloc>().add(GetSavedPhotos());
            },
            child: Text('get cache', textAlign: TextAlign.center),
          ),
          FloatingActionButton(
            onPressed: () {
              final state = context.read<PhotoBloc>().state;
              if (state is PhotoLoaded) {
                context.read<PhotoBloc>().add(SavePhotos(state.photos));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Нет доступных данных для сохранения')),
                );
              }
            },
            child: Text('save cache', textAlign: TextAlign.center),
          ),
        ],
      ),

    );
  }
}
