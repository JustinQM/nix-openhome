{
    lib,
    appimageTools,
    fetchurl,
    makeWrapper,
}:
let
    pname = "openhome";
    version = "1.18.0";

    src = fetchurl
    {
        url = "https://github.com/andrewbenington/OpenHome/releases/download/v${version}/OpenHome_${version}_amd64.AppImage";
        hash = "sha256-FbB9B8gh7gYjxpjMDGowFH0yIVZO07nadry7ggvNDaQ=";
    };

    contents = appimageTools.extract
    {
        inherit pname version src;
    };
in
appimageTools.wrapType2
{
    inherit pname version src;

    extraInstallCommands = ''
        source "${makeWrapper}/nix-support/setup-hook"
        wrapProgram $out/bin/${pname} --set WEBKIT_DISABLE_DMABUF_RENDERER 1

        install -Dm444 ${contents}/*.desktop -t $out/share/applications
        sed -i 's|^Exec=.*|Exec=${pname} %U|' $out/share/applications/*.desktop
        cp -r ${contents}/usr/share/icons $out/share/
    '';

    meta =
    {
        description = "Import and transfer Pokemon between save files";
        homepage = "https://github.com/andrewbenington/OpenHome";
        license = lib.licenses.gpl3Only;
        platforms = [ "x86_64-linux" ];
        mainProgram = pname;
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
}
