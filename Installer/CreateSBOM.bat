@echo off
@setlocal
:: =============================================================================
:: SBOM�쐬�p�o�b�`�t�@�C��
:: �ΏہF.NET Framework 4.7.2 �A�v���P�[�V����
::
:: �K�v�Ȏ��O�����F
::   - sbom-tool ���C���X�g�[������Ă��邱��
::     �� winget �܂��� dotnet tool �o�R�œ����\
::        winget: winget install Microsoft.SbomTool
::        dotnet: dotnet tool install --global Microsoft.Sbom.DotNetTool
::
:: ���s���e�F
::   1. bin\Release �t�H���_��Ώۂ�SBOM�𐶐�
::
:: �o�͐�F
::   - ./_sbom/manifest.spdx.json
::
:: ���l�F
::   - ���̃t�@�C���� Installer �t�H���_���ɔz�u���A�[�i�O�Ɏ��s����
::   - Inno Setup ��SBOM���܂߂�ꍇ�́A{app}\_sbom �ɔz�u����
:: =============================================================================

:: �A�v�����ƌ��J�t�H���_�̃p�X��ݒ�
@set BUILD_DROP_PATH=..\src\ConsistRunner\bin\Release
@set OUTPUT_PATH=.
@set PACKAGE_NAME=ConsistRunner
@set PACKAGE_SUPPLIER=SampleWorks

@rem �J�����g�t�H���_�Ɉړ�
cd /d %~dp0

@echo SBOM�t�@�C���쐬
@echo.

:: �o�[�W�����ԍ������[�U�[�������
@set /p PACKAGE_VERSION="���͂��Ă��������i��: 1.0.0�j�� �o�[�W�����ԍ�: "

:: ���̓`�F�b�N�i�󕶎��̂Ƃ��͏I���j
@if "%PACKAGE_VERSION%"=="" (
    @echo �o�[�W���������͂���Ă��܂���B�����𒆎~���܂��B
    @exit /b 1
)

@echo �[�i���Ȃ��t�@�C�����폜���܂�...
@echo.

:: �s�v�t�@�C�����폜
del /f /q "%BUILD_DROP_PATH%\*.pdb"
del /f /q "%BUILD_DROP_PATH%\*.xml"

@echo �o�[�W����: %PACKAGE_VERSION% ���g�p����SBOM�𐶐����܂�...
@echo.

:: SBOM�c�[�����s�i�o�͂� _sbom �t�H���_�Ɋi�[�j
sbom-tool generate ^
  -b "%BUILD_DROP_PATH%" ^
  -m "%OUTPUT_PATH%" ^
  -pn "%PACKAGE_NAME%" ^
  -pv "%PACKAGE_VERSION%" ^
  -ps "%PACKAGE_SUPPLIER%"

@endlocal
@pause