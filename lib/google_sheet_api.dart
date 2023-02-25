import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "fine-doodad-378820",
  "private_key_id": "9e502ff102de4d9dff5cad7c96425cfdead10242",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDNcQIE7kkTGVfn\nJ3CwhXg7aPXnnJLQAV364TsW0Yd4wggWglRvlUVDT1PyrW0C+hR1tQCmsczxymoI\nZnCbW2MLQ0Qj0p9TW3ZaWgNIAWcMORCQDIEQvuq3DRhFBQJo9R37hsdwUhSCCa0A\nTj4m1M6gXcnsZXfOmr5IFZUR/C3QraNKWUiaRs6fGpT9BPDJzXC9V1nJZzR2JQ2A\nAMnJQY1bBYERKwysJAWqVyTQLc2QRa2/vnbGGtxZSQQ3uVW/yVOAMSDZ3TVZNM93\nI9zDCGSUM3CtxLdR/fG8K/sfM3ysRjVc0R8QC4q5KJUQD9WBh5rnQExxCoOBgmE3\nEQbc5Vl7AgMBAAECggEAKmu903/Slf+DL6dstP5yY64aLL+fbxUBL2cnmOAeHZjP\nK7qwrbPAcBQmzPLzkgxKgj2kS0dmfrzhpSdl9CZsLqyumskIfiFiMGjqyYkEmrkD\nywLR+b+6Xp71Fndg1oRasw/TCcXhFzLhRrFhUwpZOjLzmX0gPoikZuUR+Xs9iJub\nZXchWD4esXwYk2x8tOLSTf41jhokxZyqECoIwrG4DZXi5R3N1WBQLcFBqdXQZ2Lq\neSc5Oe6srr529zc309iGU/W13qFjivEnukjvzYT6+eNK3WpUyJaPmS3k1JhQhGAp\nKfVZbR2gXl7H2Auvgfw0j0Lvn1Iu49Eo15J01j39GQKBgQDpVOHV1m6IV4KBFuk8\nMYFcGaKTL3lLlLWUzTgKAGWCu7JlYsSX7ngDIFlsDrARuS6IpK28CDvB5zs1W9Gz\nkkmeAPy6kw+YRzlygFlFjs1vMO0WbUASoQ2roaZgp8FwCkEkJAnv4g9ZFa574zIt\nA3GqPrvHVJUGA30/nE/RzmvjmQKBgQDhZnqQVdmjRpYBT+cX+HQza+/1QVXVvaUW\n77chBnlVzcvjA5m7jgtmZLJWWulvgS4ri7lthvwGnyGhKRp0T60M/YGRIKa8J56i\n3XLIpUGsn9pPdKkJY983XMVWA5yET3OLVNxYeh4HK0XYKMxM6Pl8x72uX+mmDRxI\nfo16soBSMwKBgQCZKSGw5zfZAXBl4i8pVumuFhm0ecYqCayDx43QauA3R5Pbn1Ci\n1mMq0jJAjweeKqtUAJ0WP2VSa8Fezi3BrPXr5IQAyIXFFIOuGHgBA7LwGPKX9RDI\n6bT6g3qeGaANNn36BjoLn50pgeTt533JNGiJMvK57liAAQxXE/kFJHWHiQKBgQCe\nQHIa9nuYXE2jXDM3LDSBie3uttGKAN1xDhr4L/Buos/cckG0YhV07YwcfzXYGM2O\nu0oUMSqvh3h4C0DMmsg4D6CxgUgvYG3LkUkuwIAssAr5sEGiGyG0YAkYy+5PIu1P\nzOPrpsmAZQxjqLlP4l6QEjkFvcdw01GhQGEa3Uqk6wKBgQDH615lZrHbRI52mcMu\nsa8rJIP+dqkaVlW8TEY8Hq03D1sz6LutEKh8o7x+sx+7gucLXINtKBRvdOMen2NE\nSe8hRH/o/lrpimiJI+hNyOnksDc0z4EWTmmraNFzsGbndTew2Obfb+WhYz7t5Lod\nMsy9nbX1IpyA80WR3mVASuPoLQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "money-management-gsheet@fine-doodad-378820.iam.gserviceaccount.com",
  "client_id": "115994685168054097877",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/money-management-gsheet%40fine-doodad-378820.iam.gserviceaccount.com"
}

  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1BxO7SeEneCMZsd_wFQAvMOnqR-B8l55_4jnDyYVKNns';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
