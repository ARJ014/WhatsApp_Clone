import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  static const name = "/user_info_screen";
  const UserInfoScreen({super.key});

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  final nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  void selectImage(context) async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void saveUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(AuthControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                (image == null)
                    ? const CircleAvatar(
                        backgroundImage: NetworkImage(
                            'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIoAAACKCAMAAABCWSJWAAAAZlBMVEX///8AAACqqqrv7+/8/Py5ubn5+fn29vba2tolJSXg4ODy8vLCwsILCwtycnLn5+eIiIixsbEYGBhUVFQ/Pz8uLi54eHhPT0/R0dEfHx9nZ2ekpKTJyclHR0eVlZU0NDRdXV2AgIC/bEkpAAAEZklEQVR4nO1a25aqMAwduckdARFERfj/nzy6xqZFBEKbOueh+3GmDds0SXPpz4+BgYGBgYGBgYGBwf8GL4zdPHdjf/+nLPw4LZLdC0nRur73J0TsSwk0gE55sb9OxB/eaTAM/leJ2OlEIYJq2i9qxgrmiTwRXL5ExC6XiTxRZt9g0hzXmex29+YLTDBEnrjqZuK+ffCWdvnV969ul97e/pXrZXIdfSwYfMFZbP8wNudYJ5NM/FJlTWKrY93FFaE+JrZ4Bt3HS2ffCRHnqC/AnPhXzrNW2QinlOpiIphsuXAPe7120/XOnMnySs6l0HNVd9yDV3ITr+YWpYNJBkoJVrMkDxyp0OFFXCmIeHHVqhZQCsotBrY6obeWmMmuUJduBkfkklOBn3nArYfzPFEz2cPhR7gNHmygLgV8JrjF7kjZDurM5bL56CE2U/tQ+5J7RseJLNiqRxwcls8e8XtY4lk6pFRsJrfH72GKvNOm3GH1kjvg9xxeWwLa2O+zWLvBBpmlF7Tlol+85Fr4Pa5mKhvqvlwTFYkD6vRQgdttQ7bKMuGK1mz3LNev8XsgFBHn/Uxuhb7cHKZI4hDH6w50Kdywgog6S4DLDe1CFtuxwf9RgBI1wO6ANI661eJBjYpMP6D5cSRPbiFBRN75kDkhE9ANgDQO16vg1YeG9hNUfBXGOcFSbvRMhOIdoXJev+ko4L0SL57TrrW0/qEoW41zTQErNTXBWs5l0RaFJiZxig3gvYTFM8r5qkJbJ1n4yO4040fOICyijvkCDsJnio+KycV+KX10E1ALH9rd3bdMxI5HTXcdIYUjGjf4g4Gzsd1DNfrnXfMsxpmOPar+dOrvkz/XxBnTFF49+ehH6IltYzjdOo+HxX5noBmvM6Hven3EtV8YHP4iKWPtlvJQCWpI9jBmrSOYB5p+nQRDqXVmd1knIKLTdkrh3NkEc8Peu6bxdzyx1qoerCbL7AeyrLGGupqQ0TKFmYSTQzxJAbL4MFlFTsRJx19IZyNH/LayJw67UStKT9rFPkU4frFA/ERhdAn2q8YYjphTJgt7MZocUUF9FAkJz2gQxJZIdduiYsj6GqLvbGgLivGQyI/E4f+mi0V64xyiSlrglXtSQOFG3GSTzfdbyMtEAjdypXXyhHBGyleAMHKXqq94FZcgJ32z4HeKpBNw91P06BCUcpQMU7yJp9hg51ebtJwQRCi1FfgrHoUYxY9IpdkPUiqFsADDPpXZagRhQckTeTyQ/0FchgoT4WWF/C+CQKv4JhLa/b2shJAl8rjHGfOIWJ/hLOuHcD7KzT0Y4cie0MAEKD+HhJ6l7Os0tl/9gocTkrT/SPWnCAAFy/0qaKMQvCne/uZkBAi1BIUvXERyFwiYPUU/gMmSyhQcVj0kBEwg4LYyPbqItSI3TLnnwQK31Pw7Y5k+yfSCJT6BTOCGOQdJaccSU6lZCKRNJJUduKNM+hRZv7iQdPf8y0ucat5vYGBgYGBgYGBgYLAB/wAozyxlWNtgYgAAAABJRU5ErkJggg=='),
                        radius: 60,
                      )
                    : CircleAvatar(
                        backgroundImage: FileImage(image!),
                        radius: 60,
                      ),
                Positioned(
                  bottom: -10,
                  left: 75,
                  child: IconButton(
                      onPressed: () {
                        selectImage(context);
                      },
                      icon: const Icon(Icons.add_a_photo)),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(hintText: "Enter your name")),
                ),
                IconButton(
                    onPressed: () {
                      saveUserData();
                    },
                    icon: const Icon(Icons.done))
              ],
            )
          ],
        ),
      )),
    );
  }
}
