import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//secure Repository에 저장하는 것이므로, 킷값을 임의로 설정해도 무방.
const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

//dio에 사용하는것이므로, 서버와 약속된 킷값이어야 함.
const AUTHORIZATION_KEY = 'authorization';

final emulatorIp = '10.0.2.2:3000';
final simulatorIp = '127.0.0.1:3000';

final ip = Platform.isIOS ? simulatorIp : emulatorIp;