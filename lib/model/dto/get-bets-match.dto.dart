class GetBetsMatchDTO {
  int idRound = 0;
  int idTeamHome = 0;
  int idTeamOutside = 0;

  GetBetsMatchDTO(this.idRound, this.idTeamHome, this.idTeamOutside);

  Map<String, dynamic> toJson() {
    return {
      "idRound": idRound,
      "idTeamHome": idTeamHome,
      "idTeamOutside": idTeamOutside
    };
  }
}
