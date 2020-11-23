class StateName {
  int id;
  String staten;
  String name;

  StateName(this.id,this.staten, this.name);

  static List<StateName> getState() {
    return <StateName>[
      StateName(0,'Overall', 'Overall'),
      StateName(1,'Abia', 'Abia'),
      StateName(2,'Adamawa', 'Adamawa'),
      StateName(3,'Akwa Ibom', 'Akwa Ibom'),
      StateName(4,'Anambra', 'Anambra'),
      StateName(5,'Bauchi', 'Bauchi'),
      StateName(6,'Bayelsa', 'Bayelsa'),
      StateName(7,'Benue', 'Benue'),
      StateName(8,'Borno', 'Borno'),
      StateName(9,'Cross Rivers', 'Cross Rivers'),
      StateName(10,'Delta', 'Delta'),
      StateName(11,'Ebonyi', 'Ebonyi'),
      StateName(12,'Edo', 'Edo'),
      StateName(12,'Ekiti', 'Ekiti'),
      StateName(13,'Enugu', 'Enugu'),
      StateName(15,'Gombe', 'Gombe'),
      StateName(16,'Imo', 'Imo'),
      StateName(17,'Jigawa', 'Jigawa'),
      StateName(18,'Kaduna', 'Kaduna'),
      StateName(19,'Kano', 'Kano'),
      StateName(20,'Katsina', 'Katsina'),
      StateName(21,'Kebbi', 'Kebbi'),
      StateName(22,'Kogi', 'Kogi'),
      StateName(23,'Kwara', 'Kwara'),
      StateName(24,'Lagos', 'Lagos'),
      StateName(25,'Nasarawa', 'Nasarawa'),
      StateName(26,'Niger', 'Niger'),
      StateName(27,'Ogun', 'Ogun'),
      StateName(28,'Ondo', 'Ondo'),
      StateName(29,'Osun', 'Osun'),
      StateName(30,'Oyo', 'Oyo'),
      StateName(31,'Plateau', 'Plateau'),
      StateName(32,'Rivers', 'Rivers'),
      StateName(33,'Sokoto', 'Sokoto'),
      StateName(34,'Taraba', 'Taraba'),
      StateName(35,'Yobe', 'Yobe'),
      StateName(36,'Zamfara', 'Zamfara'),
      StateName(37,'FCT', 'FCT'),
    ];
  }
}