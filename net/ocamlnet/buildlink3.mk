# $NetBSD: buildlink3.mk,v 1.9 2018/01/07 13:04:27 rillig Exp $

BUILDLINK_TREE+=	ocamlnet

.if !defined(OCAMLNET_BUILDLINK3_MK)
OCAMLNET_BUILDLINK3_MK:=

BUILDLINK_API_DEPENDS.ocamlnet+=	ocamlnet>=4.1.2
BUILDLINK_ABI_DEPENDS.ocamlnet+=	ocamlnet>=4.1.4nb3
BUILDLINK_PKGSRCDIR.ocamlnet?=		../../net/ocamlnet

.endif	# OCAMLNET_BUILDLINK3_MK

BUILDLINK_TREE+=	-ocamlnet
