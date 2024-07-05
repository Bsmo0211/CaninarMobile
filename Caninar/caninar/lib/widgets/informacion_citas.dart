import 'package:caninar/API/APi.dart';
import 'package:caninar/constants/principals_colors.dart';
import 'package:caninar/models/citas/model_informacion_det_cita.dart';
import 'package:caninar/models/marcas/model.dart';
import 'package:caninar/models/mascotas/model.dart';
import 'package:caninar/models/user/model.dart';
import 'package:caninar/shared_Preferences/shared.dart';
import 'package:caninar/widgets/boton_custom.dart';
import 'package:caninar/widgets/calendario_custom.dart';
import 'package:caninar/widgets/cards_items_home.dart';
import 'package:caninar/widgets/custom_appBar.dart';
import 'package:caninar/widgets/custom_drawer.dart';
import 'package:caninar/widgets/info_detallada_adiestrador.dart';
import 'package:caninar/widgets/informacion_detallada_cita_cliente.dart';
import 'package:caninar/widgets/informacion_detallada_cita_paseador.dart';
import 'package:caninar/widgets/redireccion_atras.dart';
import 'package:caninar/widgets/seleccion_fecha_cita.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class InformacionCitas extends StatefulWidget {
  List<InformacionDetalladaCitaModel> informacionDetalle;
  String? estado;
  String? titulo;
  bool proxima;
  bool? terminado;
  InformacionCitas({
    super.key,
    required this.informacionDetalle,
    required this.titulo,
    required this.proxima,
    required this.estado,
  });

  @override
  State<InformacionCitas> createState() => _InformacionCitasState();
}

class _InformacionCitasState extends State<InformacionCitas> {
  List<MarcasModel>? marcas;
  List<MascotasModel>? mascotas;
  UserLoginModel? user;
  UserLoginModel? userById;
  bool isApiCallProcess = false;
  List<InformacionDetalladaCitaModel> infoDetalladaCita = [];

  getCurrentUser() async {
    UserLoginModel? userTemp = await Shared().currentUser();

    setState(() {
      user = userTemp;
    });
  }

  getInformacionById() async {
    setState(() {
      isApiCallProcess = true;
    });
    List<MarcasModel> marcastemp = [];
    List<MascotasModel> mascotasTemp = [];
    UserLoginModel? userByIdTemp;
    for (InformacionDetalladaCitaModel detalle in widget.informacionDetalle) {
      String idUser = detalle.idUser!;
      String idSupplier = detalle.supplierId!;
      String idPet = detalle.petId!;
      MarcasModel? marcaTemp = await API().getSupplierById(idSupplier);
      MascotasModel mascotaTemp = await API().getPetById(idPet);

      userByIdTemp = await API().getUserByid(idUser);

      if (marcaTemp != null) {
        marcastemp.add(marcaTemp);
      }
      if (mascotaTemp != null) {
        mascotasTemp.add(mascotaTemp);
      }
    }

    setState(() {
      marcas = marcastemp;
      mascotas = mascotasTemp;
      infoDetalladaCita = widget.informacionDetalle;
      userById = userByIdTemp;
    });

    setState(() {
      isApiCallProcess = false;
    });
  }

  void recibirDiasSeleccionados(List<DateTime> selectedDays) {
    DateTime dia = selectedDays.first;
    String formattedDate = DateFormat('dd/MM/yyyy').format(dia);

    List<InformacionDetalladaCitaModel> detallesFiltrados = [];

    for (var infoDetalle in widget.informacionDetalle) {
      if (infoDetalle.time?.date == formattedDate) {
        detallesFiltrados.add(infoDetalle);
      }
    }

    setState(() {
      infoDetalladaCita = detallesFiltrados;
    });
  }

  @override
  void initState() {
    getCurrentUser();
    getInformacionById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isApiCallProcess) {
      EasyLoading.show(status: 'Cargando');
    } else {
      EasyLoading.dismiss();
    }
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: CustomDrawer(),
      body: RefreshIndicator(
          child: Column(
            children: [
              RedireccionAtras(nombre: widget.titulo!),
              Expanded(
                child: ListView(
                  children: [
                    if (widget.proxima)
                      const Center(
                        child: Text(
                            'Recuerda que puedes buscar tus citas por dia!'),
                      ),
                    if (widget.proxima)
                      CalendarioCustom(
                        type: 1,
                        onDiasSeleccionado: recibirDiasSeleccionados,
                      ),
                    if (marcas != null)
                      infoDetalladaCita.isEmpty
                          ? const Center(
                              child: Text(
                                  'No tienes citas agendadas para ese dia'),
                            )
                          : Column(
                              children: infoDetalladaCita
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = entry.key;
                                bool? terminado = false;                        
                                if (entry.value.status != null) {
                                  if (entry.value.status!
                                      .contains('terminated')) {
                                    terminado = true;
                                  }
                                }

                                MarcasModel marca = marcas![index];
                                MascotasModel mascota = mascotas![index];
                                return CardItemHome(
                                  terminadoCitas: terminado,
                                  titulo: user?.type == 2
                                      ? mascota.name!
                                      : marca.name!,
                                  imageCard: user?.type == 2
                                      ? mascota.image
                                      : marca.image!,
                                  redireccion: () {
                                    
                                    user?.type == 2
                                        ? entry.value.time!.date == ''
                                            ? Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SeleccionFechaCita(
                                                          idSchedule:
                                                              entry.value.id ??
                                                                  '',
                                                        )),
                                              )
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        InformacionDetalladaCitaPaseador(
                                                          formatoHora: entry.value.duration ?? '00:00:00',
                                                          estado: terminado!,
                                                          idSchedule:
                                                              entry.value.id!,
                                                          nombreRedireccion:
                                                              mascota.name!,
                                                          mascota: mascota,
                                                          direccion: entry
                                                              .value.direccion!,
                                                        )),
                                              )
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    InformacionDetalladaCitaCliente(
                                                      formatoHora: entry.value.duration ?? '00:00:00',
                                                          estadoTermiando: terminado!,
                                                      direccion: entry
                                                          .value.direccion!,
                                                      estado: widget.estado!,
                                                      idSchedule:
                                                          entry.value.id!,
                                                      nombreRedireccion:
                                                          marca.name!,
                                                      mascota: mascota,
                                                    )),
                                          );
                                  },
                                  precios: widget.estado!.contains('pending') &&
                                          entry.value.time!.date == ''
                                      ? GestureDetector(
                                          child: Image.asset(
                                            'assets/images/wpp.png',
                                            width: 35,
                                          ),
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (contextDialog) {
                                                  return AlertDialog(
                                                    title: const Center(
                                                        child: Text(
                                                      'Importante',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                    content: const Text(
                                                        textAlign:
                                                            TextAlign.justify,
                                                        'Recuerda si no logras contactar a la otra persona, te sugiero que te dirijas a soporte para obtener ayuda en cómo establecer contacto con ella.'),
                                                    actions: [
                                                      Center(
                                                        child: BotonCustom(
                                                          funcion: () {
                                                            user?.type == 2
                                                                ? API().launchWhatsApp(
                                                                    userById?.telephone !=
                                                                            null
                                                                        ? '51${userById?.telephone}'
                                                                        : '51919285667')
                                                                : API().launchWhatsApp(
                                                                    marca.telephone !=
                                                                            null
                                                                        ? '51${marca.telephone}'
                                                                        : '51919285667');
                                                            Navigator.pop(
                                                                contextDialog); // Cierra el diálogo
                                                          },
                                                          texto:
                                                              'Ir a WhatsApp',
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                        )
                                      : Text(
                                          '${entry.value.time?.date} \n${entry.value.time?.hour?.start}-${entry.value.time?.hour?.end}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                  colorTexto: Colors.black,
                                  icono: Icon(
                                    Icons.star,
                                    color: PrincipalColors.orange,
                                  ),
                                );
                              }).toList(),
                            )
                  ],
                ),
              )
            ],
          ),
          onRefresh: () async {
            await getInformacionById();
          }),
    );
  }
}
