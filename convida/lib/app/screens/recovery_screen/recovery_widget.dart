import 'package:convida/app/screens/recovery_screen/recovery_controlle.dart';
import 'package:convida/app/shared/util/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class RecoveryWidget extends StatefulWidget {
  @override
  _RecoveryWidgetState createState() => _RecoveryWidgetState();
}

class _RecoveryWidgetState extends State<RecoveryWidget> {
  final RecoveryController recoveryController = RecoveryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recuperando Senha"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              SizedBox(height: 10),
              Center(
                  child: Text(
                'Informações Necessárias',
                style: TextStyle(
                    color: Color(0xFF295492),
                    fontSize: 22,
                    fontWeight: FontWeight.w500),
              )),
              SizedBox(height: 20),
              Center(
                child: Observer(
                  builder: (BuildContext context) {
                    return Column(
                      children: <Widget>[
                        textFieldInitialValue(
                            icon: Icons.email,
                            initalValue: recoveryController.recovery.password,
                            onChanged: recoveryController.recovery.setPassword,
                            maxLength: 50,
                            labelText: "Favor entre com seu e-mail cadastrado",
                            errorText:
                                recoveryController.validadeRecoveryEmail),
                        SizedBox(
                          height: 10,
                        ),
                        textFieldInitialValue(
                            icon: Icons.person,
                            initalValue: recoveryController.recovery.user,
                            onChanged: recoveryController.recovery.setUser,
                            maxLength: 50,
                            labelText: "Favor entre com seu GRR",
                            errorText: recoveryController.validadeRecoveryUser)
                      ],
                    );
                  },
                ),
              ),
              Observer(builder: (BuildContext context) {
                return Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Color(0xFF8A275D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: recoveryController.loading == true
                      ? null
                      : () async {
                          recoveryController.postRecovery(context);
                        },
                  padding: EdgeInsets.fromLTRB(24, 12, 24, 12),
                  child: Text('Recuperar',
                      //Color(0xFF295492),(0xFF8A275D)
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              );
              },),
              //SizedBox(height: 10),
              Center(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(14.0, 12, 8, 12),
                child: Text(
                  'Obs.: Essa recuperação somente é válida para os usuário com GRR, aqueles que usam o login @ufpr devem recorrer a Intranet para Recuperar/Alterar sua senha UFPR',
                  style: TextStyle(
                      color: Color(0xFF8A275D),
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
