# $NetBSD: buildlink3.mk,v 1.18 2024/04/06 08:05:21 wiz Exp $

BUILDLINK_TREE+=	SDL2_ttf

.if !defined(SDL2_TTF_BUILDLINK3_MK)
SDL2_TTF_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.SDL2_ttf+=	SDL2_ttf>=2.0.12
BUILDLINK_ABI_DEPENDS.SDL2_ttf+=	SDL2_ttf>=2.22.0nb2
BUILDLINK_PKGSRCDIR.SDL2_ttf?=		../../fonts/SDL2_ttf

.include "../../devel/SDL2/buildlink3.mk"
.include "../../devel/zlib/buildlink3.mk"
.include "../../fonts/harfbuzz/buildlink3.mk"
.include "../../graphics/freetype2/buildlink3.mk"
.endif # SDL2_TTF_BUILDLINK3_MK

BUILDLINK_TREE+=	-SDL2_ttf
