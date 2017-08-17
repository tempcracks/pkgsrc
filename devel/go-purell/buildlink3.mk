# $NetBSD: buildlink3.mk,v 1.1 2017/08/17 01:37:13 gavan Exp $

BUILDLINK_TREE+=	go-purell

.if !defined(GO_PURELL_BUILDLINK3_MK)
GO_PURELL_BUILDLINK3_MK:=

BUILDLINK_CONTENTS_FILTER.go-purell=	${EGREP} gopkg/
BUILDLINK_DEPMETHOD.go-purell?=		build

BUILDLINK_API_DEPENDS.go-purell+=	go-purell>=0.1.0
BUILDLINK_PKGSRCDIR.go-purell?=		../../devel/go-purell

.endif  # GO_PURELL_BUILDLINK3_MK

BUILDLINK_TREE+=	-go-purell

